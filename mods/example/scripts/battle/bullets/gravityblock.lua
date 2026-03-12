local GravityBlock, super = Class(Bullet)

function GravityBlock:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/cobblestone/cobblestone")

    self.collider = Hitbox(self, self.width/4, self.height/4, self.width/2, self.height/2)
    self.physics.direction = dir
    self.physics.speed = speed
    --self:setScale(1) --apparently making scale too small makes the hitbox disappear. use this to see it
    self:setScale(0.5)
    self.remove_offscreen = true
    self.physics.gravity_direction = math.pi/2
    self.physics.gravity = 0.7
    self.sprite.anim_speed = MathUtils.random(1,2)
end

return GravityBlock