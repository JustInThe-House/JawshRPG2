local item, super = Class(Item, "overalls")

function item:init()
    super.init(self)
-- probably will remove since already wearing overalls
    -- Display name
    self.name = "Overalls"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "With a mustache, makes you look like your favorite plumber.\nGives the BLJitter attack."
    -- considering adding "definding gives extra TP", but it doesnt really fit any playstyle. wont for now."

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
        defense = 2
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Run Killer"
    self.bonus_icon = "ui/menu/icon/armor"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        jawsh = true
    }

    -- Character reactions
    self.reactions = {}
end

function item:onEquip(chara)
    Game.world:startCutscene(function (cutscene)
        cutscene:text("* Yahoo!", "happy", "jawsh")
        cutscene:after(function ()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(2)
            Game.world.menu.box.state = "SLOTS"
        end)
    end)
    return true
end

return item
