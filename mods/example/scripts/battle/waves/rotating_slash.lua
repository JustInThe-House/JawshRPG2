local rotating_slash, super = Class(Wave)

function rotating_slash:init()
    super.init(self)
    self.time = 10
    self.timer_rate = 0
    self.slash_count = 0
    self.cooldown = 40
    self.line_angle = {}
    self.special_reattack = false
    self.enemy_movement_x, self.enemy_movement_y = MathUtils.random(16, 83), MathUtils.random(25, 130)
    Game.battle:getEnemyBattler("soyingjawsh").manual_move = true

    local img = love.graphics.newImage(Mod.info.path .. "/assets/sprites/particles/line.png")
    self.particles = love.graphics.newParticleSystem(img, 180)
    self.particles:setColors(0.8, 0, 0.8, 1, 0.8, 0, 0.8, 0)


    self.particles:setParticleLifetime(0.75, 2)
    self.particles:setEmissionRate(0)

    -- self.particles:setLinearAcceleration(-50,-50,50,50)
    self.particles:setSpread(math.pi / 16)
    self.particles:setRotation(math.pi / 2)

    self.particles:setRelativeRotation(true)
end

function rotating_slash:getRemainingTime()
    return self.time - Game.battle.wave_timer
end

function rotating_slash:update()
    if self:getRemainingTime() > 1.5 and not self.special_reattack then
        self.timer_rate = self.timer_rate + DTMULT
        if self.timer_rate >= self.cooldown then
            local x = Game.battle.soul.x
            local y = Game.battle.soul.y
            local angle = MathUtils.random(0, 2*math.pi)
            if Game.battle.encounter.difficulty == 0 then
                if self.slash_count == 0 then
                    self.line_angle = { angle }
                elseif self.slash_count <= 2 then
                    self.line_angle = { angle, angle + math.rad(90) }
                elseif self.slash_count <= 4 then
                    self.line_angle = { angle, angle + math.rad(60), angle + math.rad(120) }
                else
                    self.line_angle = { angle, angle + math.rad(45), angle + math.rad(90), angle + math.rad(135) }
                end
            elseif Game.battle.encounter.difficulty == 1 then
                if self.slash_count <= 1 then
                    self.line_angle = { angle, angle + math.rad(60), angle + math.rad(120) }
                elseif self.slash_count <= 4 then
                    self.line_angle = { angle, angle + math.rad(45), angle + math.rad(90), angle + math.rad(135) }
                else
                    self.line_angle = { angle, angle + math.rad(36), angle + math.rad(72), angle + math.rad(108), angle +
                    math.rad(144) }
                end
            elseif Game.battle.encounter.difficulty == 2 then
                if self.slash_count <= 1 then
                    self.line_angle = { angle, angle + math.rad(90) }
                else
                    self.line_angle = { angle, angle + math.rad(45), angle + math.rad(90), angle + math.rad(135) }
                end
            else
                if self.slash_count <= 1 then
                    self.line_angle = { angle }
                elseif self.slash_count <= 4 then
                    self.line_angle = { angle, angle + math.rad(90) }
                elseif self.slash_count <= 8 then
                    self.line_angle = { angle, angle + math.rad(60), angle + math.rad(120) }
                else
                    self.line_angle = { angle, angle + math.rad(45), angle + math.rad(90), angle + math.rad(135) }
                end
            end
            self:spawnBulletTo(Game.battle.mask, "circle_gradient", x, y, 0, 2, { 0.8, 0, 0.8 })
            self:spawnBulletTo(Game.battle.mask, "circle_gradient", x, y, 0, 1.75, { 0.8, 0, 0.8 })
            self:spawnBulletTo(Game.battle.mask, "circle_gradient", x, y, 0, 1.5, { 0.8, 0, 0.8 })
            local rand = 1
            if Game.battle.encounter.difficulty == 1 then
                rand = TableUtils.pick({ -1, 1 })
            end

            for i = 1, #self.line_angle do
                if Game.battle.encounter.difficulty == 2 then
                    rand = rand * -1
                end
                self:spawnBulletTo(Game.battle.mask, "rotatingslash_line", x, y, self.line_angle[i],
                                   (1.5 / #self.line_angle) + 0.05 * #self.line_angle, rand)
            end
            self.slash_count = self.slash_count + 1
            self.timer_rate = 0

            Game.battle:getEnemyBattler("soyingjawsh"):slideTo(Game.battle:getEnemyBattler("soyingjawsh").xstart + (self.enemy_movement_x % 100) - 100,
                                           Game.battle:getEnemyBattler("soyingjawsh").ystart + (self.enemy_movement_y % 160) - 80, 0.3,
                                           "linear") -- add and after function
            self.enemy_movement_x, self.enemy_movement_y = self.enemy_movement_x + MathUtils.random(16, 83),
                self.enemy_movement_y + MathUtils.random(25, 130)
            Game.battle:getEnemyBattler("soyingjawsh"):setAnimation("slice_prep")
            if Game.battle:getEnemyBattler("soyingjawsh").arm.alpha ~= 0 then
                Game.battle:getEnemyBattler("soyingjawsh").arm.alpha = 0
            end
            self.timer:after(0.85, function()
                Game.battle:getEnemyBattler("soyingjawsh"):setAnimation("slice")
                self.timer:after(0.05, function()
                    for i = 1, #self.line_angle do
                    if Game.battle.encounter.difficulty == 2 then
                    rand = rand * -1
                end
                        self.particles:setDirection(self.line_angle[i] + math.rad(57)*rand)
                        self.particles:setPosition(x, y)
                        local speedmin, speedmax = 300, 500
                        self.particles:setSpeed(speedmin, speedmax)
                        self.particles:emit(12)
                        self.particles:setSpeed(-speedmax, -speedmin)
                        self.particles:emit(12)
                    end
                end)
            end)
        end
    elseif Game.battle.encounter.difficulty == 9 and self:getRemainingTime() <= 1.5 and not self.special_reattack then
        self.time = self.time + 5
        self.special_reattack = true
    elseif self:getRemainingTime() > 0.5 and self.special_reattack then
    end


    self.particles:update(DT)
    super.update(self)
end

function rotating_slash:draw()
    if self.particles ~= nil then
        love.graphics.draw(self.particles, 0, 0)
        super.draw(self)
    end
end

function rotating_slash:onEnd()
    if Game.battle.encounter.difficulty == 9 then
        Game.battle.encounter.difficulty = 3
    end
    Game.battle:getEnemyBattler("soyingjawsh"):resetSprite()
    Game.battle:getEnemyBattler("soyingjawsh").arm.alpha = 1
    Game.battle:getEnemyBattler("soyingjawsh"):slideTo(Game.battle:getEnemyBattler("soyingjawsh").xstart, Game.battle:getEnemyBattler("soyingjawsh").ystart, 0.5, "linear",
                                   function()
                                       Game.battle:getEnemyBattler("soyingjawsh").siner = 0
                                       Game.battle:getEnemyBattler("soyingjawsh").manual_move = false
                                   end)
end

return rotating_slash
