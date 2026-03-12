local rotating_slash, super = Class(Wave)
-- added to rotating slash. no longer needed.
function rotating_slash:init()
    super.init(self)
    self.time = 13
    self.timer_rate = 15
    self.slash_count = 0
    self.cooldown = 26
end

function rotating_slash:getRemainingTime()
    return self.time - Game.battle.wave_timer
end

function rotating_slash:update()
    if self:getRemainingTime() > 0.5 then
        self.timer_rate = self.timer_rate + DTMULT
        if self.timer_rate >= self.cooldown then
            local x = Game.battle.soul.x
            local y = Game.battle.soul.y
            local angle = Utils.random(0, 360)
            self:spawnBulletTo(Game.battle.mask, "circle_gradient", x, y, 0, 2, { 0.8, 0, 0.8 }) -- was 1,0,0
            self:spawnBulletTo(Game.battle.mask, "circle_gradient", x, y, 0, 1.75, { 0.8, 0, 0.8 })
            self:spawnBulletTo(Game.battle.mask, "circle_gradient", x, y, 0, 1.5, { 0.8, 0, 0.8 })
            local rand = Utils.pick({ -1, 1 })
                if self.slash_count <= 1 then
                    self:spawnBulletTo(Game.battle.mask, "rotatingslash_line", x, y, angle, rand)
                elseif self.slash_count <= 3 then
                    self:spawnBulletTo(Game.battle.mask, "rotatingslash_line", x, y, angle, 1)
                    self:spawnBulletTo(Game.battle.mask, "rotatingslash_line", x, y, angle + math.rad(90), 1)
                elseif self.slash_count <= 5 then
                    self:spawnBulletTo(Game.battle.mask, "rotatingslash_line", x, y, angle, 1)
                    self:spawnBulletTo(Game.battle.mask, "rotatingslash_line", x, y, angle + math.rad(60), 1)
                    self:spawnBulletTo(Game.battle.mask, "rotatingslash_line", x, y, angle + math.rad(120), 1)
                else
                    self:spawnBulletTo(Game.battle.mask, "rotatingslash_line", x, y, angle, 1)
                    self:spawnBulletTo(Game.battle.mask, "rotatingslash_line", x, y, angle + math.rad(45), 1)
                    self:spawnBulletTo(Game.battle.mask, "rotatingslash_line", x, y, angle + math.rad(90), 1)
                    self:spawnBulletTo(Game.battle.mask, "rotatingslash_line", x, y, angle + math.rad(135), 1)
                    
                end


            self.slash_count = self.slash_count + 1
            self.timer_rate = 0
        end
    end
    super.update(self)
end

return rotating_slash
