local item, super = Class(HealItem, "tenburgers")

function item:init()
    super.init(self)

    -- Display name
    self.name = "TenBurgers"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Big heal\nGet fat"
    -- Shop description
    self.shop = "Mysterious\nhamburger\nheals 300HP"
    -- Menu description
    self.description = "Let's make this guy fat.\nHeals 300HP, but move slower if used in battle."

    -- Amount healed (HealItem variable)
    self.heal_amount = 300
    --[[Amount this item heals for specific characters in the overworld (optional)
    self.world_heal_amounts = {
        ["noelle"] = 20
    }]]

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
            cutscene:text("* I'll do that for you.", "smile", "jawsh")
        elseif target.name == "Berd" then
            cutscene:text("* It's me, Winston Overwatch.", "smile", "berd")
        elseif target.name == "Vinny" then
            cutscene:text("* -Rubs suspciously large belly-", "neutral", "vinny")
        end
        cutscene:after(function()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(1)
        end)
    end)
    return super.onWorldUse(self, target)
end

function item:onBattleUse(user, target)
    target:heal(Game.battle:applyHealBonuses(self.heal_amount, user.chara))
    target.chara:addStatBuff("soul_speed", -0.075)
end

return item