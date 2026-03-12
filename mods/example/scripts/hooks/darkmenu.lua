local DarkMenu, super = HookSystem.hookScript(DarkMenu)

function DarkMenu:init()
    super.super.init(self, 0, -80)

    self.layer = WORLD_LAYERS["ui"]

    self.parallax_x = 0
    self.parallax_y = 0

    self.animation_done = false
    self.animation_timer = 0
    self.animate_out = false

    self.selected_submenu = 1

    self.item_header_selected = 1
    self.equip_selected = 1
    self.power_selected = 1

    self.item_selected_x = 1
    self.item_selected_y = 1

    self.selected_party = 1
    self.party_select_mode = "SINGLE" -- SINGLE, ALL
    self.after_party_select = nil

    self.selected_item = 1

    self.state = "MAIN"
    self.state_reason = nil
    self.heart_sprite = Assets.getTexture("player/heart_menu_small")

    self.ui_move = Assets.newSound("ui_move")
    self.ui_select = Assets.newSound("ui_select")
    self.ui_cant_select = Assets.newSound("ui_cant_select")
    self.ui_cancel_small = Assets.newSound("ui_cancel_small")

    self.font = Assets.getFont("main")

    self.description_box = Rectangle(0, 0, SCREEN_WIDTH, 80)
    self.description_box:setColor(0, 0, 0)
    self.description_box.visible = false
    self.description_box.layer = 10
    self:addChild(self.description_box)

    self.description = Text("", 20, 10, SCREEN_WIDTH - 20, 80 - 16)
    self.description_box:addChild(self.description)

    self.buttons = {}
    self:addButtons()
    self.buttons = Kristal.callEvent(KRISTAL_EVENT.getDarkMenuButtons, self.buttons, self) or self.buttons

    self.box = nil
    self.box_offset_x = 0
    self.box_offset_y = 0
end



function DarkMenu:onKeyPressed(key)
    if self.box then
        if self.box.onKeyPressed then
            self.box:onKeyPressed(key)
        end
    end

    if (Input.isMenu(key) or Input.isCancel(key)) and self.state == "MAIN" then
        Game.world:closeMenu()
        return
    end

    if not self.animation_done then return end

    if self.state == "MAIN" then
        local old_selected = self.selected_submenu
        if Input.is("left", key)  then self.selected_submenu = self.selected_submenu - 1 end
        if Input.is("right", key) then self.selected_submenu = self.selected_submenu + 1 end
        if self.selected_submenu < 1             then self.selected_submenu = #self.buttons end
        if self.selected_submenu > #self.buttons then self.selected_submenu = 1             end
        if old_selected ~= self.selected_submenu then
            self.ui_move:stop()
            self.ui_move:play()
        end
        if Input.isConfirm(key) then
            self:onButtonSelect(self.selected_submenu)
        end
    elseif self.state == "PARTYSELECT" then
        if Input.isCancel(key) then
            Input.clear("cancel")
            self.ui_cancel_small:stop()
            self.ui_cancel_small:play()

            self.state = self.state_reason
            if self.after_party_select then
                self.after_party_select(false)
            end

            self:updateSelectedBoxes()
            return
        end
        local old_selected = self.selected_party
        if self.party_select_mode == "SINGLE" then
            if Input.is("left", key) then
                self.selected_party = self.selected_party - 1
                self.ui_move:stop()
                self.ui_move:play()
            end
            if Input.is("right", key) then
                self.selected_party = self.selected_party + 1
                self.ui_move:stop()
                self.ui_move:play()
            end
        end
        if self.selected_party < 1 then self.selected_party = #Game.party end
        if self.selected_party > #Game.party then self.selected_party = 1 end
        if old_selected ~= self.selected_party then
            self:updateSelectedBoxes()
        end
        if Input.isConfirm(key) then
            Input.clear("confirm")
            self.state = self.state_reason
            self.state_reason = nil
            if self.after_party_select then
                if self.party_select_mode == "SINGLE" then
                    self.after_party_select(true, Game.party[self.selected_party])
                else
                    self.after_party_select(true, Game.party)
                end
            end
            self:updateSelectedBoxes()
        end
    end
end


function DarkMenu:drawButton(index, x, y)
    local button = self.buttons[index]
    local sprite = button.sprite
    if index == self.selected_submenu then
        sprite = button.hovered_sprite
    end
    Draw.setColor(1, 1, 1)
    Draw.draw(sprite, x, y, 0, 2, 2)
    if index == self.selected_submenu and self.state == "MAIN" then
        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, x + 15, y + 25, 0, 0.25, 0.25, self.heart_sprite:getWidth() / 2, self.heart_sprite:getHeight() / 2)
    end
end

return DarkMenu