local item, super = Class(Item, "airbag")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Airbag"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/cookie_cutter"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Puffy\narmor"
    -- Menu description
    self.description = "An already inflated Jeep airbag.\nHigher defense when at full health."

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
        airbag = 6
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Airbag"
    self.bonus_icon = "ui/menu/icon/fluff"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {}
end

function item:onEquip(chara)
    --  Game.world:startCutscene("pyro_congrats", "wall")

    --figure out what will set the specific previous armor chosen
    Game.world:startCutscene(function (cutscene)
        if chara.name == "Jawsh" then
            cutscene:text("* At least it works.", "neutral", "jawsh")
        elseif chara.name == "Vinny" then
            cutscene:text("* commonJeepL", "neutral", "vinny")
        end
        cutscene:after(function ()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(2) -- for the equipmenu
            Game.world.menu.box.state = "SLOTS"

            --Game.world.menu.box.party.focused = true -- ignore or set to true to make it so you can move characters as you select
            --  Game.world:openMenu(DarkStorageMenu())
        end)
    end)

    return true
end

return item
