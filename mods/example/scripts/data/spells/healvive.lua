local spell, super = Class(Spell, "revheal")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Rev-Heal"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    if Game.chapter <= 3 then
        self.effect = "Heal/Rev\nAlly"
    else
        self.effect = "Heal/Rev\nally"
    end
    -- Menu description
    self.description = "Heavenly light restores a little HP to\none party member. Depends on Magic."

    -- TP cost
    self.cost = 40

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"

    -- Tags that apply to this spell
    self.tags = {"heal"}
end

function spell:onCast(user, target)
    local base_heal = user.chara:getStat("magic") * 2.5
    if target.chara:getHealth() <= 0 then
        base_heal = base_heal + math.abs(target.chara:getHealth())
    end
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