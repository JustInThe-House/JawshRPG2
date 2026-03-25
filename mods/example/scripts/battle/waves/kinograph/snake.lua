local Snake, super = Class(Wave)

function Snake:init()
    super.init(self)
    self.time = 6.5
end

function Snake:onStart()
    local arena = Game.battle.arena
    self.attackers = self:getAttackers()
    for _, attacker in ipairs(self.attackers) do
        self.timer:every(0.5 + MathUtils.random(0.15, 0.25) * (#Game.battle.enemies - 1), function()
            local t0 = MathUtils.random(0, 2 * math.pi)
            local x, y =
                arena.x +
                arena.width * 2 * (math.sin(t0) + math.cos(t0)) / (math.abs(math.sin(t0)) + math.abs(math.cos(t0))),
                arena.y + arena.height * 2 * (math.sin(t0) - math.cos(t0)) /
                (math.abs(math.sin(t0)) + math.abs(math.cos(t0)))
            self:spawnBullet("kinograph/snake", x, y)
        end)
    end
end

return Snake
