local tunnel_360, super = Class(Wave)

function tunnel_360:init()
    super.init(self)
    --self:setArenaRotation(78)
    self:setArenaSize(213, 142)
    self.time = 10.5
    self.timer_rate = 0
    self.rand = TableUtils.pick({ -1, 1 })
    self.spawn_x = 0
    self.movement = 0
    self.cooldown = 0.12
    self.siner = 0
    self.rotate = 0
    self.rand2 = MathUtils.random(0, 3)
    self.retarget = false
    self.prepare = false
    self.sword_count = 0
    self.targetx, self.targety = 0, 0
    self.targetspeed = MathUtils.random(0.25, 0.75)
    self.targetrange = MathUtils.random(20, 50)
end

function tunnel_360:getRemainingTime()
    return self.time - Game.battle.wave_timer
end

function tunnel_360:update()
    if self:getRemainingTime() >= 1.5 then

        self.timer_rate = self.timer_rate + DT

        if not self.prepare and self.sword_count > 5 then
            self.timer:tween(7,self, {rotate = self.rand*2*math.pi})
            self.prepare = true
        end
        if self.prepare then
            self.siner = self.siner + DTMULT
            self.targetx, self.targety = self.targetx + DT * self.targetspeed, self.targety + DT * self.targetspeed
        end

        if self.timer_rate >= self.cooldown then
            local r1 = 350
            local r2 = 76 --+ 5 * math.sin(math.rad(self.siner))

            local x = Game.battle.arena.x + r1 *
                --math.cos(math.rad(self.rotate + 11 * math.sin(math.rad(self.rand2 * self.siner))))
                math.cos(self.rotate)
            local y = Game.battle.arena.y + r1 *
                math.sin(self.rotate)
            --[[local angle = Utils.angle(x, y,
                                      Game.battle.arena.x + self.targetrange * math.cos(self.targetx) +
                                      r2 * math.sin(math.rad(self.rotate + 180)),
                                      Game.battle.arena.y + self.targetrange * math.sin(self.targety) +
                                      r2 * math.cos(math.rad(self.rotate + 180)))]]
            local angle = Utils.angle(x, y,
                                       Game.battle.arena.x ,
                                       Game.battle.arena.y  )
            local push = -2

            --self:spawnBullet("sword_tunnel", x + r2 * math.sin(math.rad(self.rotate + 90)),
                      --       y + r2 * math.cos(math.rad(self.rotate + 90)), angle, push, angle + math.rad(-90), self.rand)
            self:spawnBullet("sword_tunnel", x - r2*math.cos(self.rotate + math.pi/2),
                             y- r2*math.sin(self.rotate + math.pi/2), angle, push, angle-math.pi/2)        
            self:spawnBullet("sword_tunnel", x + r2*math.cos(self.rotate + math.pi/2),
                             y+ r2*math.sin(self.rotate + math.pi/2), angle, push, angle-3*math.pi/2)
            self.sword_count = self.sword_count + 1
            self.timer_rate = self.timer_rate - self.cooldown
        end
    elseif self:getRemainingTime() < 3 and not self.retarget then
        -- angle swords toward heart, max of 60deg or heart angle
        for _, swords in ipairs(self.bullets) do
            swords.retarget = true
        end
        self.retarget = true
    end

    super.update(self)
end

return tunnel_360
