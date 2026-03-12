local item, super = Class(Item, "walkingshoes")

function item:init()
    super.init(self)

    -- Display name
    self.name = "WalkingShoes"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Broken but usable"
    -- Menu description
    self.description = "Lightly worn black sneakers.\n+25% movement speed in the overworld."

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
    self.bonuses = {}
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "World Walker"
    self.bonus_icon = "ui/menu/icon/clock"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {}
end

function item:onEquip(chara)
    Game:setFlag("walkingshoes", true)
    Game.world:startCutscene(function (cutscene)
        if chara.name == "Jawsh" then
            cutscene:text("* Walk with me!", "happy", "jawsh")
        elseif chara.name == "Vinny" then
            cutscene:text("* Gotta do a beer mile in these!", "neutral", "vinny")
        end
        cutscene:after(function ()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(2)
            Game.world.menu.box.state = "SLOTS"
        end)
    end)
    return true
end

function item:onUnequip(chara)
    local shoes_on = -1
    for _,party_member in ipairs(Game.party) do
        if select(1, party_member:checkArmor("walkingshoes")) then
            shoes_on = shoes_on + 1
        end
    end
    if shoes_on <= 0 then
            Game:setFlag("walkingshoes", false)
    end
    return super.onUnequip(self, chara)
end

return item
