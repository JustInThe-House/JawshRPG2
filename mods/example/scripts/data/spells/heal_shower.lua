local spell, super = Class(Spell, "healshower")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Heal Shower"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    if Game.chapter <= 3 then
        self.effect = "Heal\nallies"
    else
        self.effect = "Heal\nallies"
    end
    -- Menu description
    self.description = "Heavenly rain restores a little HP to\nall party members. Depends on Magic."

    -- TP cost
    self.cost = 32

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "party"

    -- Tags that apply to this spell
    self.tags = {"heal"}
end

function spell:onCast(user, target)
    local base_heal = user.chara:getStat("magic") * 2
    local heal_amount = Game.battle:applyHealBonuses(base_heal, user.chara)

    target:heal(heal_amount)
end

function spell:hasWorldUsage(chara)
    return true
end

function spell:onWorldCast(chara)
    Game.world:heal(chara, 100)
end

return spell