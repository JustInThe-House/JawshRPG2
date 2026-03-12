local Dust, super = Class(Bullet)

function Dust:init(x, y, dir, speed, color)
    -- Last argument = sprite path
    super.init(self, x, y, "particles/minecraft_dust")

    self.physics.direction = dir
    self.rotation = MathUtils.random(0,2*math.pi)
    self.collider = CircleCollider(self, self.width/2, self.height/2, self.width/2-1)
    self.color = color
    self.physics.speed = speed
    self:setScale(2, 2)
    self.remove_offscreen = false
    self.rotation_speed = TableUtils.pick({-1,1})*speed/3

end

function Dust:onWaveSpawn(wave)
    self.wave.timer:tween(2.0, self.physics, {speed = 0}, "in-quad")
    self.wave.timer:after(1.6, function ()
        self.collidable = false
        self:fadeOutAndRemove(0.4)
    end)
end

function Dust:update()
    self.rotation = self.rotation + self.rotation_speed*DT
    super.update(self)
end

return Dust