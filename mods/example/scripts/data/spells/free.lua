local spell, super = Class(Spell, "BLJitterrrr")
-- try to do this through the spell rather than through a cutscene. should be easier. use berd buster as example. must create object to house the button count presses
function spell:init()
    super.init(self)

    -- Display name
    self.name = "BLJitterrrr"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Yahoo\ndamage"
    -- Menu description
    self.description = "Jump backwards to build up speed and\ndamage one enemy."

    -- TP cost
    self.cost = 0

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemies"

    -- Tags that apply to this spell
    self.tags = { "damage" }
end

function spell:getCastMessage(user, target)
    return ""
end

function spell:getTPCost(chara)
    local cost = super.getTPCost(self, chara)
    if chara and chara:checkWeapon("devilsknife") then
        cost = cost - 10
    end
    return cost
end

function spell:onCast(user, target)
    user.chara:addStatBuff("did_attack", 1)
end

function spell:onStart(user, target)
            Game.battle:startActCutscene("BLJitterCutscene")
end

return spell