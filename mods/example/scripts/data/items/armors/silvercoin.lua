local item, super = Class(Item, "silvercoin")

function item:init()
    super.init(self)

    -- Display name
    self.name = "SilverCoin"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A silver quarter bought at the price peak.\nIncreases dropped money by 10%"

    -- Default shop price (sell price is halved)
    self.price = 50
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
        defense = 3,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "$ +10%"
    self.bonus_icon = "ui/menu/icon/money"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {}
end

function item:onEquip(chara)
    Game.world:startCutscene(function (cutscene)
        --Bite it to make sure it's real!
        if chara.name == "Jawsh" then
            cutscene:text("* It's an investment!", "happy", "jawsh")
        elseif chara.name == "Vinny" then
            cutscene:text("* I used to eat quarters as a kid", "neutral", "vinny")
        end
        cutscene:after(function ()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(2)
            Game.world.menu.box.state = "SLOTS"
        end)
    end)
    return true
end

function item:applyMoneyBonus(gold)
    return gold * 1.1
end

return item
