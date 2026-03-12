local starshot, super = Class(Wave)
-- weaker starchilds die earlier. add this
-- starshot lags when redirecting the bullets, maybe because its repeatedly being called?
--its not bullet afterimages, must be someting else
function starshot:init()
    super.init(self)
    --  self:setArenaOffset(0, 70)
    --self:setArenaRotation(78)
    self:setArenaSize(167, 127)
    Game.battle.encounter.difficulty = 2
    if Game.battle.encounter.difficulty <= 1 then
        self.time = 9
    else
        self.time = 10
    end
    self.star_angle = MathUtils.random(0, 32)
    self.timer_rate = 0
    self.chase = false
    self.explode = false
    if Game.battle.encounter.difficulty <= 1 then
        self.summon_to_stop = 4.75
        self.stop_to_explode = 3.5
    else
        self.summon_to_stop = 6.75
        self.stop_to_explode = 5.5
    end
    self.shaking = false
    self.arena_push = 8

    Game.battle:getEnemyBattler("soyingjawsh").manual_move = true
    Game.battle:getEnemyBattler("soyingjawsh"):slideTo(Game.battle:getEnemyBattler("soyingjawsh").xstart+3, Game.battle:getEnemyBattler("soyingjawsh").ystart+17, 0.35, "outQuad")
    Game.battle:getEnemyBattler("soyingjawsh"):setAnimation("point")
    Game.battle:getEnemyBattler("soyingjawsh").arm.siner_control = 2
    self.timer:tween(0.35, Game.battle:getEnemyBattler("soyingjawsh").arm, { rotation = 0 },"out-quad")
    Assets.playSound("knightdrawpower", 3, 1.3)
    self.bulletflow = flow(0, 0)
    Game.stage:addChild(self.bulletflow)
    self.bulletflow_lines = flow_lines(0, 0)
    Game.stage:addChild(self.bulletflow_lines)
end

function starshot:getRemainingTime()
    return self.time - Game.battle.wave_timer
end

function starshot:onStart()
    --   self.bulletflow = Sprite('bullets/flow_bg')


    --   Game.battle.arena:addChild(self.bulletflow)
    --[[Game.battle.arena:addFX(MaskFX(function()
                       love.graphics.circle('fill', 160, 160, 120)
                      love.graphics.rectangle('fill', 335, 215, 240, 240)
                        end))]]
    -- well this is one way to add some shadow in the battle! halfway to the light mechanic in ch4
    --self.mask4.inverted = true
    --   self.bulletflow:addFX(self.spotlight_mask)

    -- self.bulletflow:addFX(Gradient(1,0))


        --[[   self.mask4 = self:addFX(MaskFX(function()
                       love.graphics.circle('fill', 260, 260, 120)
                      love.graphics.rectangle('fill', 115, 115, 140, 260)
                        end))]]
        --    self.mask4.inverted = true
end

function starshot:update()
    --  Game.battle.arena.rotation = 78
    -- Game.battle.arena.x = 78 for if you want to change it mid battle

    self.timer_rate = self.timer_rate + DT

    if self:getRemainingTime() >= self.time - 1 then
        self.bulletflow.mesh_length = math.min(500, self.bulletflow.mesh_length + 16 * DTMULT)
        self.bulletflow_lines.mesh_length = math.min(500, self.bulletflow_lines.mesh_length + 16 * DTMULT)
    elseif self:getRemainingTime() >= self.summon_to_stop and self:getRemainingTime() < self.time - 1 then
        if not self.shaking then
            Game.battle.arena:shake(TableUtils.pick({ -0.75, 0.75 }), TableUtils.pick({ -1, 1 }), 0, 2 / 30)
            Assets.playSound("blast_long", 1, 0.6)
            Game.battle:getEnemyBattler("soyingjawsh").alternator = 1
            self.shaking = true
        end
        self.bulletflow.mesh_width = self.bulletflow.mesh_width + 6 * DTMULT
        self.bulletflow_lines.mesh_width = self.bulletflow_lines.mesh_width + 6 * DTMULT

        -- there is a way to make it so the bullets go below the spotlight, making them blink in and out if they have an afterimage.

        Game.battle.arena.x = Game.battle.arena.x - 1 * DTMULT
        if self.timer_rate >= 0.14 then
            local attacker = Game.battle:getEnemyBattler("soyingjawsh")
                local x, y = attacker:getRelativePos((attacker.width / 2)-45, (attacker.height / 2)-2)
                Assets.playSound("stars", 1, 0.5)
                Assets.playSound("soy", 0.65, 0.95)

                local speed = 7 + MathUtils.random(-1, 1)
                if Game.battle.encounter.difficulty == 2 then
                    speed = speed / 1.2
                end
                local angle = Utils.angle(x, y, Game.battle.arena.x, Game.battle.arena.y)
                self:spawnBullet("star", x, y, angle + math.rad(((self.star_angle) % 32) - 16),
                                 speed)
                self.star_angle = self.star_angle + MathUtils.random(9, 13)
            self.timer_rate = 0
        end
    elseif self:getRemainingTime() < self.summon_to_stop and not self.chase then
        Game.battle.arena:stopShake()
        for _, stars in ipairs(self.bullets) do
            stars.stop = true
        end
        Assets.playSound("stars_chase", 2)

        Game.battle:getEnemyBattler("soyingjawsh"):setAnimation("point_reverse")
        Game.battle:getEnemyBattler("soyingjawsh").alternator = 0
        self.timer:tween(0.6, Game.battle:getEnemyBattler("soyingjawsh").arm, { rotation = -math.pi / 4 }, "in-quad")

        self.timer:after(0.7, function()
            Game.battle:getEnemyBattler("soyingjawsh"):resetSprite()
                Game.battle:getEnemyBattler("soyingjawsh"):slideTo(Game.battle:getEnemyBattler("soyingjawsh").xstart, Game.battle:getEnemyBattler("soyingjawsh").ystart, 0.5, "outQuad")

        end)
        self.chase = true
    elseif self:getRemainingTime() < self.stop_to_explode and not self.explode then
        for _, stars in ipairs(self.bullets) do
            stars.explode = (stars.x + 200) / 1200
        end
        self.explode = true
    end
    --local stars = Game.stage:getObjects(Registry.getBullet("smallbullet"))
    if self.chase and self.arena_push > 0 then
        Game.battle.arena.x = Game.battle.arena.x - self.arena_push * DTMULT
        self.arena_push = self.arena_push - DTMULT
    end
    if self.chase then
        self.bulletflow.mesh_width = math.max(self.bulletflow.mesh_width - 70 * DTMULT, 0)
        self.bulletflow_lines.mesh_width = math.max(self.bulletflow_lines.mesh_width - 70 * DTMULT, 0)
    end
    super.update(self)
end

function starshot:onEnd()
    self.bulletflow:remove()
    self.bulletflow_lines:remove()
    Game.battle:getEnemyBattler("soyingjawsh").siner = 0
    Game.battle:getEnemyBattler("soyingjawsh").manual_move = false
    Game.battle:getEnemyBattler("soyingjawsh").arm.siner_control = 0
end

return starshot
