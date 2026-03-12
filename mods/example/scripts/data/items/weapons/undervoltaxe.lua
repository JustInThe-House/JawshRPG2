local item, super = Class(Item, "undervoltaxe")

function item:init()
    super.init(self)

    -- Display name
    self.name = "UndervoltAxe"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/axe"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Heroic &\nCool"
    -- Menu description
    self.description = "A low-power mattock that's dying to be used.\nAttack increases for each consecutive attack."

    -- Default shop price (sell price is halved)
    self.price = 150
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
        attack = 1,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Undervolt"
    self.bonus_icon = "ui/menu/icon/clock"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        berd = true,
    }

    -- Character reactions
    self.reactions = {}
end

function item:onEquip(chara)
    Game.world:startCutscene(function (cutscene)
        if chara.name == "I'll shock myself" then
            cutscene:text("* Prayge", "smile", "jawsh")
        elseif chara.name == "Berd" then
            cutscene:text("* I'm chargin' up!", "smile", "berd")
        elseif chara.name == "Vinny" then
            cutscene:text("* Crusty sock electric shock!", "mad", "vinny")
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
