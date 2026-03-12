local item, super = Class(Item, "masterwatch")

function item:init()
    super.init(self)

    -- Display name
    self.name = "MasterWatch"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A timepiece with 4 hands.\n-30% graze area, +25% TP gain and time reduction."

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
        graze_time = 0.25,
        graze_size = -0.3,
        graze_tp = 0.25,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Grazemaster"
    self.bonus_icon = "ui/menu/icon/clock"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {}
end

function item:onEquip(chara)
    Game.world:startCutscene(function(cutscene)
        if chara.name == "Jawsh" then
            cutscene:text("* OVERWORKING", "angry", "jawsh") -- a time honored tradition
        elseif chara.name == "Vinny" then
            cutscene:text("* Frankenstein hypnotism 2019", "neutral", "vinny")
        end
        cutscene:after(function()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(2)
            Game.world.menu.box.state = "SLOTS"
        end)
    end)
    return true
end

return item
