local Smoke, super = Class(WorldBullet)

function Smoke:init(x, y,rx, ry, speed)
    super.init(self, x, y, "particles/minecraft_smoke")
    self.physics.speed = 0
    self:setScale(8)
    self.collider = CircleCollider(self, self.width / 2, self.height / 2, self.width / 2 - 4)
    self.remove_offscreen = false
    self.start_x,self.start_y = x, y
    self.rx = rx
    self.ry = ry
    self.speed = speed
    self.angle = MathUtils.random(0,2*math.pi)
    self.damage = 25
end

function Smoke:update()
    self.angle = self.angle + DT*self.speed
    self.x = self.start_x + self.rx*math.cos(self.angle)
    self.y = self.start_y + self.ry*math.sin(self.angle)
    super.update(self)
end

return Smoke