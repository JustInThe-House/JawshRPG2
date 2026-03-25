local SpinPickaxe, super = Class(Wave)

function SpinPickaxe:init()
    super.init(self)
    self.time = 10
    self.num_picks = 0
    self.max_picks = 3 + Game.battle.encounter.difficulty
    self.timer_spawn = 0.3
end

function SpinPickaxe:update()
    local arena = Game.battle.arena
    local soul = Game.battle.soul
    self.timer_spawn = self.timer_spawn + DT
    if self.timer_spawn >= 0.5 and self.num_picks < self.max_picks then
        self.timer_spawn = 0
        self.num_picks = self.num_picks + 1
        local t0 = MathUtils.random(0, 2 * math.pi)
        local scale = 1.35
        local x, y =
            arena.x + scale *
            arena.width / 2 * (math.sin(t0) + math.cos(t0)) / (math.abs(math.sin(t0)) + math.abs(math.cos(t0))),
            arena.y + scale * arena.height / 2 * (math.sin(t0) - math.cos(t0)) /
            (math.abs(math.sin(t0)) + math.abs(math.cos(t0)))
        local bullet = self:spawnBullet("iron_pickaxe_spin", x, y, MathUtils.random(0, 2 * math.pi))
        self.timer:tween(0.6, bullet, { alpha = 1 }, "linear", function()
            bullet.dropping = false
            bullet.physics.gravity = 0.25
            bullet.physics.speed = MathUtils.random(5, 8)
            bullet.physics.direction = MathUtils.angle(bullet.x, bullet.y, soul.x, soul.y)
        end)
    end
    super.update(self)
end

return SpinPickaxe
