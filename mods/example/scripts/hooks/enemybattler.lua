-- includes hooks for damage calculation, resetting temporary effects (including defending)
-- includes setting TP related to attacks and defense
-- includes damage calculation for autoattack
-- set tired_percentage to 0, as I don't want to use it.
local EnemyBattler, super = HookSystem.hookScript(EnemyBattler)


function EnemyBattler:init(...)
    super.init(self, ...)
    self.tired_percentage = 0
end

function EnemyBattler:getAttackDamage(damage, battler, points)
    local attack = 0
    -- other ways attack is affected before damage calc
    if damage > 0 then
        return damage
    end
    --revenge
    if select(2, battler.chara:checkArmor("revengestick")) > 0 then
        for _, party_battler in ipairs(Game.battle.party) do
            if party_battler.is_down then
                battler.chara:addStatBuff("revenge", 1)
            end
        end
    end
    if battler.chara:getStat("revenge") > 0 then
        attack = attack + 7
    end
    -- tp amount
    attack = attack +
        MathUtils.round(select(2, battler.chara:checkArmor("delusionbrace")) * Game:getTension() / 12.5)
    -- stache
    attack = attack + select(2, battler.chara:checkArmor("stache")) * math.random(-3, 5)
    -- other, end of turn attack
    attack = attack + battler.chara:getStat("temp_attack")

    -- Kristal.Console:log(Utils.dump({attack,battler.chara:getStat("attack"),battler.chara:getStat("temp_attack")}))

    attack = attack + MathUtils.round(battler.chara:getStat("attack"))

    return ((math.max(attack - self.defense, 0) * points) / 20)
end

function EnemyBattler:onHurt(damage, battler) -- since I hooked this, if i use it, i dont need to add it to any attacks manually.
    super.onHurt(self, damage, battler)
    battler.chara:addStatBuff("did_attack", 1)
    --  Kristal.Console:log(battler.chara:getStat("undervolt"))
end

function EnemyBattler:getAttackTension(points, battler)
    -- Kristal transforms tension from 0-250 (DR) to 0-100.
    -- In Deltarune, this is (10 * 2.5), except for JEVIL where it's (15 * 2.5)
    -- And in reduced battles, it's (26 * 2.5)
    local factor = select(2, battler.chara:checkArmor("spiritsword")) * Game:getTension() / 50

    if Game.battle:hasReducedTension() then
        return (points / 65) * (1 + factor) * 1.5 -- 1.5 added to factor in that you have 1 less party member
    end
    return (points / 25) * (1 + factor) * 1.5
end

function EnemyBattler:onDefeatRun(damage, battler)
    self.hurt_timer = -1
    self.defeated = true
    Assets.playSound("deathnoise")
    Game.battle.timer:after(0.3, function()
        self:fadeOutAndRemove(1)
    end)
    self:defeat("VIOLENCED", true)
end

return EnemyBattler
