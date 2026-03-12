local Arrow, super = Class(Bullet)

function Arrow:init(x, y, dir, speed)
    super.init(self, x, y, "bullets/minecraft_arrow")

    self.collider = Hitbox(self, 0, (self.height / 2) - 2, self.width - 3, 2 * 2)
    self.rotation = dir
    self.physics.match_rotation = true
    self.physics.speed = speed
    self.physics.gravity = 0.25
    self.physics.gravity_direction = math.pi / 2
    self:setScale(0.5, 0.5)
    self.remove_offscreen = false
    --could add crit particle effect
end

return Arrow
