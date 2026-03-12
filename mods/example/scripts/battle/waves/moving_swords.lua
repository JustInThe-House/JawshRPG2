local swords, super = Class(Wave)

function swords:init()
    super.init(self)
    self.time = 10
    self.timer_rate = 15
    self.timer_speedup = 0
end

function swords:getRemainingTime()
    return self.time - Game.battle.wave_timer
end

function swords:update()
    if self:getRemainingTime() > 2 then
    self.timer_rate = self.timer_rate + (self.timer_speedup/(5.5-0.5*Game.battle.encounter.difficulty) + 1)*DTMULT
    if self.timer_rate >= 40 then
    local rand_sword_spawn = MathUtils.random(0,360)
    --     local rand2 = Utils.random(0,360)  make y have own rand to create elliptical. kinda cool
    local r = 60
    local x = Game.battle.soul.x + r*math.cos(rand_sword_spawn)
    local y = Game.battle.soul.y + r*math.sin(rand_sword_spawn)
    Assets.playSound("knight_sword_summon")
    local angle = MathUtils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)
    self:spawnBullet("sword", x, y, angle, 0, r, rand_sword_spawn,70,0)
    self.timer_rate = self.timer_rate - 40
    self.timer_speedup = self.timer_speedup + 1
    end
end
    super.update(self)

end

return swords

 -- deltarune code had it so that only a max of 2-3 swords could be active at once. may consider doing that