local item, super = Class(Item, "basiccard")

function item:init()
    super.init(self)

    -- Display name
    self.name = "BasicCard"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Basic"
    -- Menu description
    self.description = "A traditional cardpiece upon which everything is balanced.\n+4 DEF"

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
        defense = 4,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Basic"
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
    }

    -- Character reactions
    self.reactions = {}
end

function item:onEquip(chara)
    --  Game.world:startCutscene("pyro_congrats", "wall")
    Game.world:startCutscene(function (cutscene)
        if chara.name == "Jawsh" then
            cutscene:text("* How2Basic", "smile", "jawsh")
        elseif chara.name == "Vinny" then
            cutscene:text("* I mean, it's alright", "neutral", "vinny")
        end
        cutscene:after(function ()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(2)
            Game.world.menu.box.state = "SLOTS"
            --tthats a technical foul
        end)
    end)

    return true
end

return item
