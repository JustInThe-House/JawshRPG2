local item, super = Class(HealItem, "orange")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Orange"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"

    -- Battle description
    self.effect = "Heals\n140HP"
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A giant orange soaked in milk.\nTemptingly throwable. +140HP"

    -- Amount healed (HealItem variable)
    self.heal_amount = 140

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
    --  Game.world:showText("* (You tried to read the manual,\nbut it was so dense it made\nyour head spin...)")
    -- Game.world:startCutscene("pyro_congrats", "wall") -- so it only works for items?

    Game.world:startCutscene(function(cutscene)
        if target.name == "Jawsh" then
            cutscene:text("* Eughhhhhh", "neutral", "jawsh")
        elseif target.name == "Vinny" then
            cutscene:text("* I got the smaller one :(", "sad", "vinny")
        end
        cutscene:after(function()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(1)
        end)
    end)
    return super.onWorldUse(self, target)
end

return item
