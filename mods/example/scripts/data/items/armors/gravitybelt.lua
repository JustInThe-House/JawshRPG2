local item, super = Class(Item, "gravitybelt") -- NEEDS WORK

function item:init()
    super.init(self)

    -- Display name
    self.name = "GravityBelt"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A belt that grounds you (for 4,754,830 years).\nMore likely to withstand heavy attacks."
-- this is a stupid ability. its just a less niche airbag + oobleck
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
        defense = 1
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Grounded"
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
    }

    -- Character reactions
    self.reactions = {}
end

function item:onEquip(chara)
    Game.world:startCutscene(function (cutscene)
        if chara.name == "Jawsh" then
            cutscene:text("* I am grounded grounded grounded.", "sad", "jawsh")
        elseif chara.name == "Vinny" then
            cutscene:text("* My jeans won't stay on!", "mad", "vinny")
        end
        cutscene:after(function ()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(2)
            Game.world.menu.box.state = "SLOTS"
        end)
    end)
    return true
end

function item:getShopDescription()
    -- Don't automatically add item type
    return self.shop
end

return item
