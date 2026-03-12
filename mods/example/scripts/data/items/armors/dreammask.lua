local item, super = Class(Item, "dreammask")

function item:init()
    super.init(self)

    -- Display name
    self.name = "DreamMask"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Gain more TP\nfrom bullets"
    -- Menu description
    self.description = "Grazing bullets give 10% more TP.\nThat's what the point of the mask is."

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
        graze_tp = 0.1,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "TPGain"
    self.bonus_icon = "ui/menu/icon/smile"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {}
    self.mask = nil
end

function item:onEquip(chara)
    Game.world:startCutscene(function(cutscene)
        if chara.name == "Jawsh" then
            cutscene:text("* What a road trip", "happy", "jawsh")
        elseif chara.name == "Vinny" then
            cutscene:text("* I'm gonna put you in the spotlight...", "happy", "vinny")
        end
        --ITSOKAY
        cutscene:after(function()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(2)
            Game.world.menu.box.state = "SLOTS"
            self.mask = Sprite('emotes/dream_smile', 20, 30)
            self.mask:setScale(2)
            Game.stage:addChild(self.mask)
            self.bg = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
            self.bg:setColor(1, 1, 1, 0.25)
            Game.stage:addChild(self.bg)
        end)
    end)
    return true
end

function item:onUnequip(chara)
    if self.mask ~= nil then
        self.mask:remove()
    end
     if self.bg ~= nil then
        self.bg:remove()
    end   
    return super.onUnequip(self, chara)
end

return item
