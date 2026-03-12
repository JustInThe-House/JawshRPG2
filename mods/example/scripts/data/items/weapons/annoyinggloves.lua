local item, super = Class(Item, "annoyinggloves")

function item:init()
    super.init(self)

    -- Display name
    self.name = "AnnoyingGloves"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/sword"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Press hilt\nto extend"
    -- Menu description
    self.description = "Itchy orange gloves.\nGives the Annoy Ability."

    -- Default shop price (sell price is halved)
    self.price = 800
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
        defense = 4
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Annoy"
    self.bonus_icon = "ui/menu/icon/demon"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        jawsh = true,
    }

    -- Character reactions
    self.reactions = {}
end

function item:onEquip(chara)
    chara:addSpell("annoy")
    Game.world:startCutscene(function (cutscene)
        cutscene:text("* Nya Nya Nya Nya", "smile", "jawsh")
        cutscene:after(function ()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(2)
            Game.world.menu.box.state = "SLOTS"
        end)
    end)
    return super.onEquip(self, chara)
end

function item:onUnequip(chara)
    chara:removeSpell("annoy")
    return super.onUnequip(self, chara)
end

return item
