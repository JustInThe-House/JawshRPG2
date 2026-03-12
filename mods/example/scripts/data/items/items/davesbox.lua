local item, super = Class(HealItem, "davesbox")

function item:init()
    super.init(self)

    -- Display name
    self.name = "DavesBox"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"

    -- Battle description
    self.effect = "Heals\nteam\n90HP"
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A Hot Box from Dave's to share(?)\nHeals everyone 90HP."

    -- Amount healed (HealItem variable)
    self.heal_amount = 90

    -- Default shop price (sell price is halved)
    self.price = 200
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "party"
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
            cutscene:text("* This is all MINE.", "angry", "jawsh")
            cutscene:text("* We're gonna need more...", "smile", "berd")
            cutscene:text("* Perdy damn good!", "happy", "vinny") -- check if vinny has had daves
        end
        cutscene:after(function()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(1)
        end)
    end)
    return super.onWorldUse(self, target)
end

return item