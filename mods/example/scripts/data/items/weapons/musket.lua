local item, super = Class(Item, "musket")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Musket"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/scarf"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "TOTALLY not dangerous at all.\nGives the Musket Shot ability."

    -- Default shop price (sell price is halved)
    self.price = 800
    -- Whether the item can be sold
    self.can_sell = false

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
        attack = 5,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Musket Shot"
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        vinny = true,
    }

    -- Character reactions
    self.reactions = {}
end

function item:onEquip(chara)
    chara:addSpell("musket_shot")
    Game.world:startCutscene(function (cutscene)
            cutscene:text("* It's just a prank, bro!", "happy", "vinny")
        cutscene:after(function ()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(2)
            Game.world.menu.box.state = "SLOTS"
        end)
    end)
    return true
end

function item:onUnequip(chara)
    chara:removeSpell("musket_shot")
    return super.onUnequip(self, chara)
end

return item
