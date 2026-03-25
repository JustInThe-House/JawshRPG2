local Snake, super = Class(Bullet)

function Snake:init(x, y)
    super.init(self, x, y, "enemies/kinograph/head")
    self.alpha = 0
    self.collider = Hitbox(self, 0, (self.height / 2), self.width, (self.height / 4))
    self.physics.direction = 0
    self.physics.speed = 8
    self.destroy_on_hit = false
    self.remove_offscreen = false
    self.timer_turn = 0
    self.distance_check = 120
    self.distance = 0
    self.distance_before = nil
    self.arena = Game.battle.arena
    local movement = 72
    self.target_x = self.arena.x + MathUtils.random(-movement,movement)
    self.target_y = self.arena.y + MathUtils.random(-movement,movement)
    self:setScale(0.5)
end

function Snake:onWaveSpawn(wave)
    self:fadeTo(1, 0.5)
    self.physics.direction = MathUtils.angle(self.x, self.y, self.target_x, self.target_y)
    self.wave.timer:every(0.3, function ()
        self.wave:spawnBullet("kinograph/snake_trail", self.x, self.y)
    end)
end

return Snake
