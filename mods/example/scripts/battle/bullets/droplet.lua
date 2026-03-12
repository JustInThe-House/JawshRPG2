local Droplet, super = Class(Bullet)

function Droplet:init(x, y, dir, speed, fast)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/droplet")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    self.physics.speed = speed
    self.wiggle_speed = speed
    self.inv_timer = 1
    self.collider = Hitbox(self, self.width/4, self.height/3, self.width/2, self.height/3)
    self:setScale(1,1)
    self.destroy_on_hit = true
    self.rotation = dir
    self.speedup = 0
    self.timer_wiggle = MathUtils.random(0,2*math.pi)
    self.time_bonus = 0
    self.fast = fast
    self.can_graze = false
    self.physics.friction = -0.11
end

function Droplet:update()
    self.speedup = self.speedup + DTMULT
    if self.speedup > 20 then
        self.can_graze = true
    end

    self.physics.speed = self.physics.speed + self.fast*DTMULT/4.5

    self.timer_wiggle = self.timer_wiggle + (math.pi+self.wiggle_speed)*DTMULT/2
    self:setScale(1+0.04*math.sin(self.timer_wiggle), 1+0.05*math.sin(self.timer_wiggle/1.2))
    super.update(self)
end

function Droplet:shouldSwoon(damage, target, soul)
    return true
end

return Droplet