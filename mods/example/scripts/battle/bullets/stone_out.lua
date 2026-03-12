local StoneOut, super = Class(Bullet)

function StoneOut:init(x, y, dir, speed, gravity)
    super.init(self, x, y, "bullets/cobblestone/cobblestone")

    self.collider = Hitbox(self, self.width / 4, self.height / 4, self.width / 2, self.height / 2)
    self.physics.direction = dir
    self.physics.speed = speed
    --self:setScale(1) --apparently making scale too small makes the hitbox disappear. use this to see it
    self:setScale(0.4)
    self.physics.gravity_direction = math.pi / 2
    self.physics.gravity = 0.1*gravity
    self.sprite.anim_speed = 1.5
end

return StoneOut
