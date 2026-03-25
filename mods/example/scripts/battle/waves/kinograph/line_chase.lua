local LineChase, super = Class(Wave)

function LineChase:init()
    super.init(self)
    self.time = 6
end

function LineChase:onStart()
    local arena = Game.battle.arena
    self.attackers = self:getAttackers()
    for _, attacker in ipairs(self.attackers) do
            local y = arena.y + TableUtils.pick({-1,1}) * (72+ MathUtils.random(36,72))
            local pick = TableUtils.pick({-1,1})
            local x, speed = arena.x + pick * (72 + MathUtils.random(72,108)), -7 * pick
            self:spawnBullet("kinograph/linechase", x, y, speed)

        self.timer:every(0.8 + MathUtils.random(0.15, 0.25) * (#Game.battle.enemies - 1), function()
            local y = arena.y + TableUtils.pick({-1,1}) * (72+ MathUtils.random(36,72))
            local pick = TableUtils.pick({-1,1})
            local x, speed = arena.x + pick * (72 + MathUtils.random(72,108)), -7 * pick
            self:spawnBullet("kinograph/linechase", x, y, speed)
        end)
    end
end

return LineChase
