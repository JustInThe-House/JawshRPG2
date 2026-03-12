local DarkEquipMenu, super = HookSystem.hookScript(DarkEquipMenu)

function DarkEquipMenu:init()
    super.super.init(self, 82, 112, 477, 277)

    self.draw_children_below = 0

    self.font = Assets.getFont("main")

    self.ui_move = Assets.newSound("ui_move")
    self.ui_select = Assets.newSound("ui_select")
    self.ui_cant_select = Assets.newSound("ui_cant_select")
    self.ui_cancel_small = Assets.newSound("ui_cancel_small")

    self.heart_sprite = Assets.getTexture("player/heart")
    self.arrow_sprite = Assets.getTexture("ui/page_arrow_down")

    self.caption_sprites = {
        ["char"] = Assets.getTexture("ui/menu/caption_char"),
        ["equipped"] = Assets.getTexture("ui/menu/caption_equipped"),
        ["stats"] = Assets.getTexture("ui/menu/caption_stats"),
        ["weapons"] = Assets.getTexture("ui/menu/caption_weapons"),
        ["armors"] = Assets.getTexture("ui/menu/caption_armors"),
    }

    self.stat_icons = {
        ["attack"] = Assets.getTexture("ui/menu/icon/sword"),
        ["defense"] = Assets.getTexture("ui/menu/icon/armor"),
        ["magic"] = Assets.getTexture("ui/menu/icon/magic"),
    }

    self.armor_icons = {
        Assets.getTexture("ui/menu/equip/armor_1"),
        Assets.getTexture("ui/menu/equip/armor_2"),
    }

    self.bg = UIBox(0, 0, self.width, self.height)
    self.bg.layer = -1
    self.bg.debug_select = false
    self:addChild(self.bg)

    self.party = DarkMenuPartySelect(8, 48, Game.world.party_index)
    self.party.focused = true
    self:addChild(self.party)

    -- PARTY, SLOTS, ITEMS
    self.state = "PARTY"

  --  self.selected_slot = 1
  self.selected_slot = Game.world.item_index

    self.selected_item = {
        ["weapons"] = 1,
        ["armors"] = 1
    }
    self.item_scroll = {
        ["weapons"] = 1,
        ["armors"] = 1
    }
end


function DarkEquipMenu:update()
    if self.state == "PARTY" then
        if Input.pressed("cancel") then
            self.ui_cancel_small:stop()
            self.ui_cancel_small:play()
            Game.world.menu:closeBox()
            return
        elseif Input.pressed("confirm") then
            self.state = "SLOTS"

         --   self.party.focused = false
         self.party.focused = true

            self.ui_select:stop()
            self.ui_select:play()

            self.selected_slot = 1
            self:updateDescription()
        end
    elseif self.state == "SLOTS" then
        if Input.pressed("cancel") then
            self.state = "PARTY"

            self.ui_cancel_small:stop()
            self.ui_cancel_small:play()

            self.party.focused = true
            self:updateDescription()
            return
        elseif Input.pressed("confirm") then
            self.state = "ITEMS"

            self.ui_select:stop()
            self.ui_select:play()

            self:updateDescription()
        end
        local old_selected = self.selected_slot
        if Input.pressed("up") then
            self.selected_slot = self.selected_slot - 1
        end
        if Input.pressed("down") then
            self.selected_slot = self.selected_slot + 1
        end
        self.selected_slot = (self.selected_slot - 1) % 3 + 1
        if old_selected ~= self.selected_slot then
            self.ui_move:stop()
            self.ui_move:play()
            self:updateDescription()
        end
    elseif self.state == "ITEMS" then
        if Input.pressed("cancel") then
            self.state = "SLOTS"

            self.ui_cancel_small:stop()
            self.ui_cancel_small:play()

            self:updateDescription()
            return
        end
        local type = self:getCurrentItemType()
        local max_items = self:getMaxItems()
        local old_selected = self.selected_item[type]
        if Input.pressed("up", true) then
            self.selected_item[type] = self.selected_item[type] - 1
        end
        if Input.pressed("down", true) then
            self.selected_item[type] = self.selected_item[type] + 1
        end
        self.selected_item[type] = MathUtils.clamp(self.selected_item[type], 1, max_items)
        if self.selected_item[type] ~= old_selected then
            local min_scroll = math.max(1, self.selected_item[type] - 5)
            local max_scroll = math.min(math.max(1, max_items - 5), self.selected_item[type])
            self.item_scroll[type] = MathUtils.clamp(self.item_scroll[type], min_scroll, max_scroll)

            self.ui_move:stop()
            self.ui_move:play()

            self:updateDescription()
        end
        if Input.pressed("confirm") then
            --self:react()
            local item, party = self:getSelectedItem(), self.party:getSelected()
            Game.world.party_index = self.party.selected_party
            Game.world.item_index = self.selected_slot
            if not self:canEquipSelected() then
                self.ui_cant_select:stop()
                self.ui_cant_select:play()
            else
                local swap_with = (self.selected_slot == 1) and party:getWeapon() or
                    party:getArmor(self.selected_slot - 1)

                local can_continue = true

                if item and (not item:onEquip(party, swap_with)) then can_continue = false end
                if swap_with and (not swap_with:onUnequip(party, item)) then can_continue = false end
                if (not party:onEquip(item, swap_with)) then can_continue = false end
                if (not party:onUnequip(swap_with, item)) then can_continue = false end

                -- If one of the functions returned false, don't continue

                if (not can_continue) then
                    self.ui_cant_select:stop()
                    self.ui_cant_select:play()
                    return
                end

                Assets.playSound("equip")

                if self.selected_slot == 1 then
                    party:setWeapon(item)
                else
                    party:setArmor(self.selected_slot - 1, item)
                end

                Game.inventory:setItem(self:getCurrentStorage(), self.selected_item[type], swap_with)

                self.state = "SLOTS"
                self:updateDescription()
            end
        end
    end
    super.super.update(self)
end


function DarkEquipMenu:drawEquipped()
    local party = self.party:getSelected()
    Draw.setColor(1, 1, 1, 1)

    if self.state ~= "SLOTS" or self.selected_slot ~= 1 then
        local weapon_icon = Assets.getTexture(party:getWeaponIcon())
        if weapon_icon then
            Draw.draw(weapon_icon, 220, -4, 0, 2, 2)
        end
    end
    if self.state ~= "SLOTS" or self.selected_slot ~= 2 then Draw.draw(self.armor_icons[1], 220, 30, 0, 2, 2) end
    if self.state ~= "SLOTS" or self.selected_slot ~= 3 then Draw.draw(self.armor_icons[2], 220, 60, 0, 2, 2) end

    if self.state == "SLOTS" then
        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, 226, 10 + ((self.selected_slot - 1) * 30),0,0.25,0.25)
    end

    for i = 1, 3 do
        self:drawEquippedItem(i, 261, 6 + ((i - 1) * 30))
    end
end

function DarkEquipMenu:drawItems()
    local type = self:getCurrentItemType()
    local party = self.party:getSelected()
    local items = Game.inventory:getStorage(type)

    local x, y = 282, 124

    local scroll = self.item_scroll[type]
    for i = scroll, math.min(items.max, scroll + 5) do
        local item = items[i]
        local offset = i - scroll

        if item then
            local usable = false
            if self.selected_slot == 1 then
                usable = party:canEquip(item, "weapon", self.selected_slot)
            else
                usable = party:canEquip(item, "armor", self.selected_slot - 1)
            end
            if usable then
                Draw.setColor(1, 1, 1)
            else
                Draw.setColor(0.5, 0.5, 0.5)
            end
            if item.icon and Assets.getTexture(item.icon) then
                Draw.draw(Assets.getTexture(item.icon), x, y + (offset * 27), 0, 2, 2)
            end
            love.graphics.print(item:getName(), x + 20, y + (offset * 27) - 6)
        else
            Draw.setColor(0.25, 0.25, 0.25)
            love.graphics.print("---------", x + 20, y + (offset * 27) - 6)
        end
    end

    if self.state == "ITEMS" then
        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, x - 20, y + 4 + ((self.selected_item[type] - scroll) * 27),0,0.25,0.25)

        if items.max > 6 then
            Draw.setColor(1, 1, 1)
            local sine_off = math.sin((Kristal.getTime() * 30) / 12) * 3
            if scroll + 6 <= items.max then
                Draw.draw(self.arrow_sprite, x + 187, y + 149 + sine_off)
            end
            if scroll > 1 then
                Draw.draw(self.arrow_sprite, x + 187, y + 14 - sine_off, 0, 1, -1)
            end
        end
        if items.max <= 12 then
            Draw.setColor(1, 1, 1)
            for i = 1, items.max do
                local item = items[i]
                local percentage = (i - 1) / (items.max - 1)
                if self.selected_item[type] == i and item then
                    love.graphics.rectangle("fill", x + 188, y + 21 + percentage * 110, 10, 10)
                elseif self.selected_item[type] == i then
                    love.graphics.rectangle("fill", x + 189, y + 22 + percentage * 110, 8, 8)
                elseif item then
                    love.graphics.rectangle("fill", x + 191, y + 24 + percentage * 110, 4, 4)
                else
                    love.graphics.rectangle("fill", x + 192, y + 25 + percentage * 110, 2, 2)
                end
            end
        else
            Draw.setColor(0.25, 0.25, 0.25)
            love.graphics.rectangle("fill", x + 191, y + 24, 6, 119)
            local percent = (scroll - 1) / (items.max - 6)
            Draw.setColor(1, 1, 1)
            love.graphics.rectangle("fill", x + 191, y + 24 + math.floor(percent * (119 - 6)), 6, 6)
        end
    end
end
-- below is what allows the textbox to appear while equipping
function DarkEquipMenu:updateDescription(...)
    if not Game.world.menu then return end
    return super.updateDescription(self, ...)
end

function DarkEquipMenu:onRemove(parent)
    if not Game.world.menu then
        return super.super.onRemove(self, parent)
    end
    super.onRemove(self, parent)
end

return DarkEquipMenu