local item, super = Class(HealItem, "magicalcrumb")

function item:init()
    super.init(self)

    -- Display name
    self.name = "MagicalCrumb"
    -- Name displayed when used in battle (optional)
    self.use_name = "MAGICAL CRUMB"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Heals\n10 HP"
    -- Shop description
    self.shop = "Fragrant\nsauce\nheals 10HP"
    -- Menu description
    self.description = "A small shiny breadcrumb that keeps reappearing.\n+10HP"

    -- Amount healed (HealItem variable)
    self.heal_amount = 10

    -- Default shop price (sell price is halved)
    self.price = 200
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {}
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions (key = party member id)
    self.reactions = {}
end

function item:onWorldUse(target)
    Game.world:startCutscene(function(cutscene)
        if target.name == "Jawsh" then
            cutscene:text("* Not enough for me.", "neutral", "jawsh")
        elseif target.name == "Vinny" then
            cutscene:text("* Infinite egg glitch!", "neutral", "vinny")
        end
        cutscene:after(function()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(1)
        end)
    end)
    return super.onWorldUse(self, target)
end

return item