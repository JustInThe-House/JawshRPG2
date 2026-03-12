local item, super = Class(HealItem, "primesub")

function item:init()
    super.init(self)

    -- Display name
    self.name = "PrimeSub"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"

    -- Battle description
    self.effect = "Jawsh\n+200HP"
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A sandwich with a note from Ludwig:\n\"Sorry for forgetting, here's +200HP.\""

    -- Amount healed (HealItem variable)
    self.heal_amount = 200
    -- Amount healed for anyone other than Kris
    self.heal_amount_other = 40

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
    --Eww, it's got a bunch of pickles and red onions.
    Game.world:startCutscene(function(cutscene)
        if target.name == "Jawsh" then
            cutscene:text("* About time I got it.", "neutral", "jawsh")
        elseif target.name == "Vinny" then
            cutscene:text("* It's full of onions and pickles.", "sad", "vinny") -- I kicked the ball, NOT LUDWIG!! put this in ball kick attack
        end
        cutscene:after(function()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(1)
        end)
    end)
    return super.onWorldUse(self, target)
end

function item:getHealAmount(id)
    if id == "jawsh" then
        return self.heal_amount
    else
        return self.heal_amount_other
    end
end

return item
