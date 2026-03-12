local Particles, super = Class(Wave)

function Particles:init()
    super.init(self)
    self.time = 6
end

function Particles:onStart()
    self.attackers = self:getAttackers()
    local arena = Game.battle.arena
    local soul = Game.battle.soul
    for _, attacker in ipairs(self.attackers) do
        self.timer:every(0.7 + MathUtils.random(0.1,0.25) * (#Game.battle.enemies-1), function()
            local t0 = MathUtils.random(0, 2 * math.pi)
            local x, y =
                arena.x +
                arena.width / 2 * (math.sin(t0) + math.cos(t0)) / (math.abs(math.sin(t0)) + math.abs(math.cos(t0))),
                arena.y + arena.height / 2 * (math.sin(t0) - math.cos(t0)) /
                (math.abs(math.sin(t0)) + math.abs(math.cos(t0)))
            local angle = MathUtils.angle(x, y, soul.x, soul.y) + MathUtils.random(-math.pi / 16, math.pi / 16)
            self:spawnBullet("baldi/ruler_drop", x, y, angle)
        end)
    end
end

return Particles
