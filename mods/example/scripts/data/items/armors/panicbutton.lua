local item, super = Class(Item, "panicbutton")

function item:init()
    super.init(self)

    -- Display name
    self.name = "PanicButton"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "Big red button that plays a vine boom.\nSpeed increases each time you get hit."

    -- Default shop price (sell price is halved)
    self.price = 400
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        defense = 1,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Panic"
    self.bonus_icon = "ui/menu/icon/up"

    -- Equippable characters (default true for armors, false for weapons, false for this item in particular)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {}
end

--function item:canEquip(character, slot_type, slot_index)
-- Default equippable to false, like weapons
--    return self.can_equip[character.id]
--end

function item:onEquip(chara)
    local sound = Assets.newSound("vineboom")
    sound:play()
    Game.world:startCutscene(function (cutscene)
        if chara.name == "Jawsh" then
            cutscene:text("* This sucks.", "neutral", "jawsh")
        elseif chara.name == "Vinny" then
            cutscene:text("* Keep re-equipping it on me!", "happy", "vinny")
        end
        cutscene:after(function ()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(2)
            Game.world.menu.box.state = "SLOTS"
        end)
    end)
    return true
end

return item
