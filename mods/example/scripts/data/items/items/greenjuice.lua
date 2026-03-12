local item, super = Class(HealItem, "greenjuice")

function item:init()
    super.init(self)

    -- Display name
    self.name = "GreenJuice"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"

    -- Battle description
    self.effect = "Heals\n160HP over\ntime"
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "It's green. It's healthy. It's awesome.\nHeals 160HP over time."

    -- Amount healed (HealItem variable)
    self.heal_amount = 60

    -- Default shop price (sell price is halved)
    self.price = 200
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none/nil)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Character reactions (key = party member id)
    self.reactions = {}
end

function item:onWorldUse(target)
    Game.world:startCutscene(function(cutscene)
        if target.name == "Jawsh" then
            cutscene:text("* AAAAHHHH! GREENS!", "shocked", "jawsh")
        elseif target.name == "Vinny" then
            cutscene:text("* THIS'LL REPLENISH ME!! THIS'LL REPLENISH ME!", "happy", "vinny")
        end
        cutscene:after(function()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(1)
        end)
    end)
    return super.onWorldUse(self, target)
end

function item:onBattleUse(user, target)
    super.onBattleUse(self, user, target)
    target.heal_over_time = 100
end

return item
