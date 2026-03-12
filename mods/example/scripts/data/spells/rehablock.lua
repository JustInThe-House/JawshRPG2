local spell, super = Class(Spell, "rehablock")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Rehablock"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Heal+Def\nAlly"
 
    -- Menu description
    self.description = "Study magic temporarily increases defense while healing.\nStronger if target is defending."

    -- TP cost
    self.cost = 40

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"

    -- Tags that apply to this spell
    self.tags = {"heal"}
end

function spell:onCast(user, target)
  --  self.times_used = self.times_used + 1
    local base_heal = user.chara:getStat("magic") * 5
    local heal_amount = Game.battle:applyHealBonuses(base_heal, user.chara)
    target:heal(heal_amount)
    target.chara:addStatBuff("temp_defense", 2)
    -- i did have the "increased defense while defending" but i was having too much trouble and just made it general with temp defense.

end

return spell