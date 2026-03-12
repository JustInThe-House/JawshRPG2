local circle_gradient, super = Class(Bullet)

function circle_gradient:init(x, y, dir, speed, color)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/vignette_circle_transparent")
  --  self:setOriginExact(self.x,self.y)
    self.physics.direction = 0
    self.collider = nil
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = 0
    self.can_graze = false
    self.remove_offscreen = false
    self.destroy_on_hit = false
    self.time_bonus = 0
    self.timer = 0
    self.color = color
    self.limit = 20
    self.speedout = speed
end

function circle_gradient:update()
    self.timer = self.timer + DTMULT
        if self.timer <= self.limit then
        self:setScale(math.min((-1+self.speedout*(1+(self.timer/self.limit))^3),5.5),math.min((-1+self.speedout*(1+(self.timer/self.limit))^3),5.5))
        self.alpha = (1 - self.timer/self.limit)*0.8
    else
      self:remove()
        
    end
    super.update(self)
end

return circle_gradient