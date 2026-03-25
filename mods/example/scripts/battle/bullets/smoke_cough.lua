local SmokeCough, super = Class(Bullet)

function SmokeCough:init(x, y, dir, speed)
    super.init(self, x, y, "particles/minecraft_smoke")

    self.collider = CircleCollider(self, self.width / 2, self.height / 2, 3.5)
    self.physics.speed = speed
    self.physics.match_rotation = false
    self.physics.direction = dir
    self:setScale(2)
    self.physics.gravity_direction = -math.pi / 2
    self.physics.gravity = 0.15
    self.alpha = 0.5
end

function SmokeCough:draw()
    love.graphics.setBlendMode("add")
    super.draw(self)
    love.graphics.setBlendMode("alpha")
end

return SmokeCough
