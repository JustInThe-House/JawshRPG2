local swords_fast, super = Class(Wave)

function swords_fast:init()
       -- self:setArenaOffset(-60,42)
    --self:setArenaRotation(78)
   -- self:setArenaSize(156,156)
    super.init(self)
    self.time = 8.25
    self.timer_rate = 4
    self.timer_speedup = 0
    self.rand = Utils.random(0,360)

end

function swords_fast:getRemainingTime()
    return self.time - Game.battle.wave_timer
end

function swords_fast:update()
    if self:getRemainingTime() > 1 then
        self.timer_rate = self.timer_rate + (1 + self.timer_speedup/18)*DTMULT
        if self.timer_rate >= 20 then
            local r = 40
            local x = Game.battle.soul.x + r*math.sin(self.rand)
            local y = Game.battle.soul.y + r*math.cos(self.rand)
            Assets.playSound("knight_sword_summon")
            local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)
            self:spawnBullet("sword", x, y, angle, 0, r, self.rand, 90, "fast")
            self.timer_rate = self.timer_rate - 20
            self.timer_speedup = self.timer_speedup + 1
            self.rand = self.rand + Utils.random(40,320)
        end
    end

    super.update(self)

end

return swords_fast