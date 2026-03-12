local spell, super = Class(Spell, "bljitter")
-- try to do this through the spell rather than through a cutscene. should be easier. use berd buster as example. must create object to house the button count presses
function spell:init()
    super.init(self)

    -- Display name
    self.name = "BLJitter"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Yahoo\ndamage"
    -- Menu description
    self.description = "Jump backwards to build up speed and\ndamage one enemy."

    -- TP cost
    self.cost = 0

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = { "damage" }
    self.afterimage_count = 30
end

function spell:getCastMessage(user, target)
    return "* " .. user.chara:getName() .. " used " .. self:getCastName() .. "!\nSpam [bind:confirm] to build up speed!"
end

function spell:onCast(user, target)
    self.start_x = user.x
    self.start_y = user.y

    Game.battle.timer:after(1, function()
        local charge = BLJitterCharge(function(press_count)
            Game.battle.timer:every(1.1 / self.afterimage_count, function()
                                        local afterimage = AfterImage(user.sprite, 0.4)
                                        user:addChild(afterimage)
                                    end, self.afterimage_count)
            Game.battle.timer:tween(0.15, user, { x = target.x, y = target.y - target.width / 2 }, "linear", function()
                user.physics.direction = math.rad(300)
                user.physics.speed = 31.5
                user.physics.gravity = 2
                user.physics.gravity_direction = math.pi / 2
                local time_reset_sprite = 0.84
                Game.battle.timer:tween(0.84, user, { rotation = 8 * math.pi }, "out-quad")
                Game.battle.timer:after(0.5, function()
                    user.x = self.start_x - Game.battle.encounter:getPartyPosition(Game.battle:getPartyIndex("jawsh"))
                    user.y = self.start_y - 143 -- found via manual testing
                    user.physics.direction = 0
                    user.physics.speed = 11.5
                    Game.battle.timer:after(0.4, function()
                        user.physics.speed = 0
                        user.physics.gravity = 0
                        user.physics.gravity_direction = 0
                        user.rotation = 0
                        user:slideTo(self.start_x, self.start_y, 0.15)
                    end)
                end)

                local attack = math.min(48, press_count) / 4

                if user.chara:checkArmor("revengestick") then
                    for _, battler in ipairs(Game.battle.party) do
                        if battler.is_down then
                            battler.chara:addStatBuff("revenge", 1)
                        end
                    end
                end
                if user.chara:getStat("revenge") > 1 then
                    attack = attack + 6
                end
                -- tp amount
                attack = attack +
                    MathUtils.round(select(2, user.chara:checkArmor("delusionbrace")) * Game:getTension() / 12.5)
                -- stache
                attack = attack + select(2, user.chara:checkArmor("stache")) * math.random(-4, 6)
                -- attack and magic
                attack = attack + MathUtils.round(user.chara:getStat("attack")) + user.chara:getStat("magic") / 2
                local damage = MathUtils.round(math.max(attack - target.defense, 0) * 5.5)

                target:hurt(damage, user)
                Game.battle.timer:after(1, function()
                    Game.battle:finishAction()
                end)
            end)
        end)
        Game.battle:addChild(charge)
    end)
    return false
end

return spell
