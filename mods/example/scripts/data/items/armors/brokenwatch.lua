local item, super = Class(Item, "brokenwatch")

function item:init()
    super.init(self)

    -- Display name
    self.name = "BrokenWatch"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Broken but usable"
    -- Menu description
    self.description = "A pocket watch shattered from frustration.\nFaster HEART speed, reduced graze effect."

    -- Default shop price (sell price is halved)
    self.price = 400
    -- Whether the item can be sold
    self.can_sell = false

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
        graze_time = -0.75,
        graze_tp = -0.5,
        soul_speed = 0.075
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Fast Break"
    self.bonus_icon = "ui/menu/icon/clock"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {}
end

function item:onEquip(chara)
    Game.world:startCutscene(function (cutscene)
        if chara.name == "Jawsh" then
            cutscene:text("* My strange iconic watch!", "shocked", "jawsh")
        elseif chara.name == "Vinny" then
            cutscene:text("* I think DSP broke this.", "sad", "vinny")
        end
        cutscene:after(function ()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(2)
            Game.world.menu.box.state = "SLOTS"
        end)
    end)
    return true
end

return item
