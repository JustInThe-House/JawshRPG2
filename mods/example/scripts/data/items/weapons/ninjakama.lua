local item, super = Class(Item, "animefilter")

function item:init()
    super.init(self)

    -- Display name
    self.name = "AnimeFilter"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/sword"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Tsun-type\narmaments"
    -- Menu description
    self.description = "I think I like this one...\nFocus mode uses TP to increase speed."

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
        soul_focus_speed = 6,
        soul_focus_tp = 1,
        attack = 1
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Dash"
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {}
end

function item:onEquip(chara)
    Game.world:startCutscene(function (cutscene)
        if chara.name == "Jawsh" then
            cutscene:text("* Konichiwhat's up?", "happy", "jawsh") --arigato, sensei
        elseif chara.name == "Vinny" then
            cutscene:text("* おい[wait:5]おい[wait:5]おい、[wait:10]バ[wait:20]カ！", "happy", "vinny")
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
