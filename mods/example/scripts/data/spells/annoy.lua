local spell, super = Class(Spell, "annoy")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Annoy"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Taunt\nEnemies"
 
    -- Menu description
    self.description = "Taunt your enemies into attacking someone much more often.\nLasts 3 turns."

    -- TP cost
    self.cost = 16

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"

    -- Tags that apply to this spell
    self.tags = {}
end

function spell:onCast(user, target)
    Assets.playSound("orange_nyanya",2)
    target.chara:resetBuff("taunt")
    target.chara:addStatBuff("taunt", 3)
end

return spell