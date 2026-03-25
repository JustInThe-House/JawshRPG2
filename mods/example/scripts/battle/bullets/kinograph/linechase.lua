local LineChase, super = Class(Bullet)

function LineChase:init(x, y, speed)
    super.init(self, x, y, "enemies/kinograph/head")
    self.alpha = 0
    self.collider = Hitbox(self, 0, (self.height / 2), self.width, (self.height / 4))
    self.physics.direction = 0
    self.physics.speed = speed
    self.destroy_on_hit = false
    self.remove_offscreen = false
    self:setScale(0.5)
end

function LineChase:onWaveSpawn(wave)
    self:fadeTo(1, 0.5)
    self.wave.timer:every(0.5, function ()
        self.wave:spawnBullet("kinograph/linechase_trail", self.x, self.y)
    end)
end

return LineChase
