local item, super = Class(Item, "dvdcase")

function item:init()
    super.init(self)

    -- Display name
    self.name = "DVDCase"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Gain more TP\nfrom bullets"
    -- Menu description
    self.description = "The first 2 seasons of The Fluppies.\nExtra defense as more allies equip it."

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
        defense = 1,
        fluppy = 1,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Fluppy Guard"
    self.bonus_icon = "ui/menu/icon/armor"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {}
end

function item:onEquip(chara)
    Game.world:startCutscene(function (cutscene)
        if chara.name == "Jawsh" then
            cutscene:text("* I am not gonna play CS, Fluppy.", "neutral", "jawsh")
        elseif chara.name == "Vinny" then
            cutscene:text("* Would you let your prematurely birthed baby watch this?", "happy", "vinny")
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
