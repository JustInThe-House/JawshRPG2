local item, super = Class(Item, "metrognome")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Metrognome"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "The fastest tempo taker in the west.\nGraze area increases with battle length."

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
        graze_size_turn = 0.02
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Graze Build"
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {}
end

function item:onEquip(chara)
    Game.world:startCutscene(function (cutscene)
        cutscene:text("* I found the gnome video BEFORE it was popular![react:idgaf]", "mad", "jawsh",
            { reactions = { idgaf = { "No one cares, Jawsh.", 300, "bottom", "mad", "vinny" } } })
            --[[cutscene:text("* I found the gnome video BEFORE it was popular![react:idgaf1][react:fuck]", "mad", "jawsh",
            { reactions = { idgaf1 = { "No one cares, Jawsh.", 300, "bottom", "smile", "berd" }, fuck = { "", 260, "bottom", "mad", "vinny" } } })]]
        cutscene:after(function ()
            Game.world:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Game.world.menu:onButtonSelect(2)
            Game.world.menu.box.state = "SLOTS"
        end)
    end)
    return true
end

return item
