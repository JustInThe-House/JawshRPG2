local JawshFinger, super = Class(Sprite, "JawshFinger")

function JawshFinger:init(x, y)
    super.init(self, "emotes/jawsh_finger/jawsh_finger", x, y)
    self.x = self.x - self.width / 2
    self:setScaleOrigin(0.5, 0.5)
    self:setScale(2)
    self:play(0.1, true)
    self.faded = false
end

function JawshFinger:update()
    if self.faded then
        local jiggle = 2
        local scale = 0.05
        self.rotation = self.rotation + -DT*math.pi/2400
        self.x = self.x + DT*MathUtils.random(-1,1)/jiggle
        self.y = self.y + DT*MathUtils.random(-1,1)/jiggle
        self.scale_x = self.scale_x + DT*scale
        self.scale_y = self.scale_y + DT*scale
    end

    super.update(self)
end

return JawshFinger
