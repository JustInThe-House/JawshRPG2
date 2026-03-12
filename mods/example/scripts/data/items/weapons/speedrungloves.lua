local item, super = Class(Item, "speedrungloves")

function item:init()
    super.init(self)

    -- Display name
    self.name = "SpeedrunGloves"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/sword"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Black-and\norange"
    -- Menu description
    self.description = "Gloves with wings etched in the palm.\nGives the BLJitter ability."
    --Move faster in battle, but no focus mode."

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
        attack = 2,
        defense = 1
        --soul_speed = 0.15
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Run Killer"
    self.bonus_icon = "ui/menu/icon/up"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        jawsh = true,
    }

    -- Character reactions
    self.reactions = {}
end

function item:onEquip(chara)
    chara:addSpell("bljitter")
    Game.world:startCutscene(function (cutscene)
        cutscene:text("* Yahoo!", "smile", "jawsh")
        cutscene:after(function ()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(2)
            Game.world.menu.box.state = "SLOTS"
        end)
    end)
    return super.onEquip(self, chara)
end

function item:onUnequip(chara)
    chara:removeSpell("bljitter")
    return super.onUnequip(self, chara)
end


return item
