local item, super = Class(Item, "emergencyphone")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Emergency Phone"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "key"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A phone to call Mom.\nTeleports you back to the hub area."

    -- Default shop price (sell price is halved)
    self.price = 0
    -- Whether the item can be sold
    self.can_sell = false

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "world"
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

function item:onWorldUse()
    Game.world:startCutscene(function(cutscene)
        Assets.playSound("phone", 0.7)
        cutscene:text("* (You tried to call Mom.)", nil, nil)
        cutscene:text("* ...", nil, nil, { advance = false })
        cutscene:wait(1.3)
        cutscene:text("* Hey,[wait:5] Mom.", "neutral", "jawsh")
        cutscene:text("* I'm stuck.[wait:7] Can you pick me up?", "neutral", "jawsh")
        Game.fader:transition(nil, nil, { speed = 1, color = COLORS.white })
        local was_playing = Game.world.music:isPlaying()
        if was_playing then
            Game.world.music:pause()
        end
        Game.fader:transition(nil, nil, { speed = 2, color = COLORS.white })
        Assets.playSound("kristal_intro")
        cutscene:wait(2)
        cutscene:wait(cutscene:fadeOut()) -- fade to black
        cutscene:loadMap("hub")           -- load target map
        --cutscene:mapTransition(map) --apparently also works
        cutscene:wait(cutscene:fadeIn())
        if was_playing then
            Game.world.music:resume()
        end
    end)
end

return item
