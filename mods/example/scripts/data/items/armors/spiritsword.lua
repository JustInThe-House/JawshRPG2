local item, super = Class(Item, "spiritsword")

function item:init()
    super.init(self)

    -- Display name
    self.name = "SpiritSword"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/sword"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description ="A powerful voice can be heard from the blade tip.\nTP from basic attacks scales with current TP %."

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
        attack = 1,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Spirit Release"
    self.bonus_icon = "ui/menu/icon/magic"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {}
end

function item:onEquip(chara)
    Game.world:startCutscene(function (cutscene)
        if chara.name == "Jawsh" then
            cutscene:text("* Prayge", "smile", "jawsh")
        elseif chara.name == "Vinny" then
            cutscene:text("* Eeeek! g-g-g-ghost!", "shocked", "vinny")
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
