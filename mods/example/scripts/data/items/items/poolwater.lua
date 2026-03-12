local item, super = Class(HealItem, "poolwater")

function item:init()
    super.init(self)

    -- Display name
    self.name = "PoolWater"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"

    -- Battle description
    self.effect = "Heals\nteam\n999HP"
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "8oz of pure, safe pool water.\nTOTALLY fully heals all allies."

    -- Amount healed (HealItem variable)
    self.heal_amount = 999

    -- Default shop price (sell price is halved)
    self.price = 100
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "party"
    -- Where this item can be used (world, battle, all, or none/nil)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Character reactions (key = party member id)
    self.reactions = {}
end

function item:onWorldUse(target)
    Game:gameOver(Game.world.player.x, Game.world.player.y)
    return true
end

function item:onBattleUse(user, target)
    local main_chara = Game:getSoulPartyMember()
    Game:gameOver(Game.battle.party[Game.battle:getPartyIndex(main_chara.id)].x,
        Game.battle.party[Game.battle:getPartyIndex(main_chara.id)].y)
end

return item
