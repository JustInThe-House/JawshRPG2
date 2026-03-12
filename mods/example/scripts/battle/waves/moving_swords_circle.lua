local swords_circle, super = Class(Wave)

function swords_circle:init()
    super.init(self)
    self.time = 10
    self.timer_rate = 15
    self.timer_speedup = 0
    self.circle_charge = false
end

function swords_circle:onStart()
    local r = 80
    local num = 6
    local randx, randy = math.random(-30, 30), math.random(-30, 30)
    for i = 1, num do
        local angle = i * 2 * math.pi / num -- Utils.random(0,360)
        local x = Game.battle.arena.x + r * math.cos(angle)
        local y = Game.battle.arena.y + r * math.sin(angle)
        --  Kristal.Console:log(Utils.dump({x,y}))

        self:spawnBullet("sword_circle", x, y, angle, r, randx, randy)
    end
end

function swords_circle:getRemainingTime()
    return self.time - Game.battle.wave_timer
end

function swords_circle:update()
    if self:getRemainingTime() > 2 then
        self.timer_rate = self.timer_rate + (self.timer_speedup / (5.5) + 1) * DTMULT
        if self.timer_rate >= 40 then
            local rand1 = MathUtils.random(0, 360)
            --     local rand2 = Utils.random(0,360)  make y have own rand to create elliptical. kinda cool
            local r = 60
            local x = Game.battle.soul.x + r * math.sin(rand1)
            local y = Game.battle.soul.y + r * math.cos(rand1)
            Assets.playSound("knight_sword_summon")
            local angle = MathUtils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)
            self:spawnBullet("sword", x, y, angle, 0, r, rand1, 70, 0)
            self.timer_rate = self.timer_rate - 40
            self.timer_speedup = self.timer_speedup + 1
        end
    elseif self:getRemainingTime() <= 1.5 and not self.circle_charge then
        for _, swords in ipairs(self.bullets) do
            swords.targeting = true
        end
        self.timer:after(0.65, function()
            Assets.playSound("knight_cut1", 2)
            Assets.playSound("soylent", 2)
        end)

        self.circle_charge = true
    end
    super.update(self)
end

return swords_circle

-- deltarune code had it so that only a max of 2-3 swords could be active at once. may consider doing that
