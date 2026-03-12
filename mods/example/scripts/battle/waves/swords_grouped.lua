local sword_grouped, super = Class(Wave)

function sword_grouped:init()
    -- self:setArenaOffset(-60,42)
    --self:setArenaRotation(78)
    -- self:setArenaSize(156,156)
    super.init(self)
    self.time = 10
    self.timer_rate = 0
    self.timer_spawn = 0
    self.angle_move = MathUtils.random(0, 2*math.pi)
    self.spawning = false
    self.spawn_count = 0
    self.r = 105
    self.cooldown = 32
end

function sword_grouped:getRemainingTime()
    return self.time - Game.battle.wave_timer
end

function sword_grouped:update()
    if self:getRemainingTime() > 1.5 then
        self.timer_rate = self.timer_rate + DTMULT
        if self.timer_rate >= 20 then
            self.spawning = true
            self.startx = Game.battle.soul.x
            self.starty = Game.battle.soul.y
            self.anglechange = TableUtils.pick({ math.rad(-18), math.rad(18) }) -- was 20, but its crazy tbh
            self.timer_rate = self.timer_rate - self.cooldown
        end
    end
    if self.spawning then
        self.timer_spawn = self.timer_spawn + DTMULT
        if self.timer_spawn >= 2.75 then
            self.angle_move = self.angle_move + self.anglechange
            self.currentx = self.startx + self.r * math.sin(self.angle_move)
            self.currenty = self.starty + self.r * math.cos(self.angle_move)
            --      local x = Game.battle.soul.x + self.r*math.sin(math.rad(self.angle_move))
            --   local y = Game.battle.soul.y + self.r*math.cos(math.rad(self.angle_move))
            Assets.playSound("knight_sword_summon")
            local angle = MathUtils.angle(self.currentx, self.currenty, self.startx, self.starty)
            self:spawnBullet("sword2", self.currentx, self.currenty, angle, 0, self.angle_move)
            self.timer_spawn = 0
            self.spawn_count = self.spawn_count + 1
        end
        if self.spawn_count == 6 then
            self.timer_spawn = 0
            self.angle_move = self.angle_move + MathUtils.random(0, 3*math.pi/2)
            self.spawning = false
            self.spawn_count = 0
        end
    end
    super.update(self)
end

return sword_grouped
