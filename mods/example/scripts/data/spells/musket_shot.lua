local spell, super = Class(Spell, "musket_shot")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Musket Shot"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Shoot\nGun"
    -- Menu description
    self.description = "Take aim and deal high damage to targeted foe.\nDon't miss!"

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

function spell:onStart(user, target)
            Game.battle:startActCutscene("MusketShotCutscene")
end

return spell
