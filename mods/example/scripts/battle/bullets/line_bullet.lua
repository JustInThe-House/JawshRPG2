local line_bullet, super = Class(Bullet)

function line_bullet:init(x, y, dir, speed, size, color)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/pixel")

    self.rotation = dir
    self.physics.match_rotation = true
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.collider = nil
    self.remove_offscreen = false
    self.timer = 0
    self.can_graze = false
    self.color = color
    self.graphics.remove_shrunk = true
    self.size = size
end

function line_bullet:update()
    self.timer = self.timer + DT
        self:setScale(800, math.max(0,self.size-self.timer))
     --   Kristal.Console:log(self.y)
    super.update(self)
end

return line_bullet