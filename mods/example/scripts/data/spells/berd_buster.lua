local spell, super = Class(Spell, "berd_buster")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Berd Buster"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Berd\ndamage"
    -- Menu description
    self.description = "Deals moderate bird-type damage to\none foe. Depends on Attack & Magic."

    -- TP cost
    self.cost = 50

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = { "rude", "damage" }
end

function spell:getCastMessage(user, target)
    return "* " .. user.chara:getName() .. " used " .. self:getCastName() .. "!"
end

function spell:getTPCost(chara)
    local cost = super.getTPCost(self, chara)
    if chara and chara:checkWeapon("devilsknife") then
        cost = cost - 10
    end
    return cost
end

function spell:onCast(user, target)
    Game.battle.battle_ui.encounter_text:setSkippable(false)
    user.chara:addStatBuff("did_attack", 1)
    local buster_finished = false
    local anim_finished = false
    local function finishAnim()
        anim_finished = true
        if buster_finished then
            Game.battle:finishAction()
        end
    end
    if not user:setAnimation("battle/rude_buster", finishAnim) then
        anim_finished = false
        user:setAnimation("battle/attack", finishAnim)
    end
    Game.battle.timer:after(15 / 30, function()
        Assets.playSound("rudebuster_swing")
        local x, y = user:getRelativePos(user.width, user.height / 2 - 10, Game.battle)
        local tx, ty = target:getRelativePos(target.width / 2, target.height / 2, Game.battle)
        local blast = RudeBusterBeam(false, x, y, tx, ty, function(pressed)
            local damage = self:getDamage(user, target, pressed)
            if pressed > 0 then
                Assets.playSound("scytheburst")
            end
            target:flash()
            target:hurt(damage, user)
            buster_finished = true
            if anim_finished then
                Game.battle.timer:after(1, function()
                    Game.battle.battle_ui.encounter_text:setSkippable(true)
                    Game.battle:finishAction()
                end)
            end
        end)
        blast.layer = BATTLE_LAYERS["above_ui"]
        Game.battle:addChild(blast)
    end)
    return false
end

function spell:getDamage(user, target, pressed)
    local attack_other = 0
    if pressed > 0 then
        attack_other = attack_other + MathUtils.round(4 * pressed) -
        1                                                            -- this is the timed attack. need to add special on impact sprite. also make it stronger
    end
    -- other ways attack is affected before damage calc
    --revenge
        if user.chara:checkArmor("revengestick") then
        for _, battler in ipairs(Game.battle.party) do
            if battler.is_down then
                battler.chara:addStatBuff("revenge", 1)
            end
        end
    end
        if user.chara:getStat("revenge") > 1 then
        attack_other = attack_other + 6
    end
    -- tp amount
    attack_other = attack_other +
    MathUtils.round(select(2, user.chara:checkArmor("delusionbrace")) * Game:getTension() / 12.5)
    -- stache
    attack_other = attack_other + select(2, user.chara:checkArmor("stache")) * math.random(-4, 6)

    -- attack and magic
    local attack_total = attack_other + MathUtils.round(user.chara:getStat("attack")) + user.chara:getStat("magic") / 2

    return (math.max(attack_total - self.defense, 0) * 7.5 * 1.5)
end

return spell
