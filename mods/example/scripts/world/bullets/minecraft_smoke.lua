local Smoke, super = Class(WorldBullet)

function Smoke:init(x, y,angle)
    super.init(self, x, y, "particles/minecraft_smoke")
    self.physics.direction = angle
    self.physics.speed = 9
    self.physics.friction = 0.4
    self:setScale(1, 1)
    self.collider = nil
    self.remove_offscreen = true
    self.battle_fade = false
end

function Smoke:update()
    if self.physics.speed <= 0 then
        self:remove()
end
    self.alpha = self.physics.speed/2
    self.scale_x = self.scale_x +3*DT
        self.scale_y = self.scale_y +3*DT
    super.update(self)
end

return Smoke