local item, super = Class(Item, "macbook")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Macbook"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A macbook signed by you!\nDefending gives 25% more AP."

    -- Default shop price (sell price is halved)
    self.price = 600
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
        defend_tp = 0.25,
        defense = 1
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "iamtopg123!"
    self.bonus_icon = "ui/menu/icon/up"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {}
end

function item:onEquip(chara)
    Game.world:startCutscene(function (cutscene)
        if chara.name == "Jawsh" then
            cutscene:text("* Stop saying I'm lying![wait:5] I was actually hacked![react:lol]", "mad", "jawsh",
        { reactions = { lol = { "April 1st btw", 300, "bottom", "happy", "vinny" } } })
        elseif chara.name == "Vinny" then
            cutscene:text("* I am Kanye.", "neutral", "vinny")
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
