local item, super = Class(Item, "delusionbrace")

function item:init()
    super.init(self)

    -- Display name
    self.name = "DelusionBrace"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "Being on edge makes you stronger.\nTP % factors into damage calculation."

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
    self.bonuses = {}
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "TP Damage"
    self.bonus_icon = "ui/menu/icon/sword"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
    }

    -- Character reactions
    self.reactions = {}
end

function item:onEquip(chara)
    Game.world:startCutscene(function (cutscene)
        if chara.name == "Jawsh" then
            cutscene:text("* I'm being gangstalked", "shocked", "jawsh")
        elseif chara.name == "Vinny" then
            cutscene:text("* Donald Trump please SAVEME", "mad", "vinny")
        end
        cutscene:after(function ()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(2)
            Game.world.menu.box.state = "SLOTS"
        end)
    end)
    --bugsinmyskinbugsinmyskin
    return true
end

return item
