local Particles, super = Class(Wave)

function Particles:init()
    super.init(self)
    self.time = 7
end

function Particles:onStart()
    self.attackers = self:getAttackers()
    local radius = 170
    for _, attacker in ipairs(self.attackers) do
        attacker.particles_start_x = attacker.x
        attacker.particles_start_y = attacker.y
        self.timer:every(MathUtils.random(0.5, 0.7) + 0.25 * #Game.battle.enemies, function()
            attacker.alpha = 0
            self.timer:after(0.5, function()
                attacker.x = math.random(attacker.particles_start_x-100,attacker.particles_start_x)
                attacker.y = math.random(150-20,150+100)
                local x, y = attacker:getRelativePos(attacker.width / 2, attacker.height / 2)
                attacker.alpha = 1
                local speed = MathUtils.random(7, 10)
                local angle = MathUtils.random(0,  math.pi)
                local count = 20
                for i = 1, count do
                    self:spawnBullet("minecraft_dust", x, y, angle + i * 360 / count, speed, { 0.91, 0, 0.91, 1 })
                end
                Assets.playSound("minecraft/portal", 1, MathUtils.random(0.95, 1.05))
            end)
        end)
    end
end

function Particles:onEnd()
    for _, attacker in ipairs(self.attackers) do
        attacker.alpha = 0
        Game.battle.timer:tween(0.5, attacker, {alpha = 1, x =  attacker.particles_start_x, y = attacker.particles_start_y}, "in-expo")
        attacker.particles_start_x = nil
        attacker.particles_start_y = nil
    end
end

return Particles
