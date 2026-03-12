local Wheel, super = Class(Event, "wacky_wheel")

function Wheel:init(data)
    super.init(self, data.x, data.y)

    local scale = 3
    self.speed = 0
    self.sprite = Sprite("world/events/wacky_wheel")
    self.sprite:setOrigin(0.5,0.5)
    self.sprite:setScale(scale)
    self:addChild(self.sprite)

    --self.sprite:setSize(self.sprite:getSize())
        

    local hitbox_offset = 5
    self:setHitbox(-hitbox_offset*scale, -hitbox_offset*scale, 2*hitbox_offset*scale, 2*hitbox_offset*scale)

end

function Wheel:update()
    super.update(self)
    self.speed = MathUtils.approach(self.speed, 0, DT/10)
    self.sprite.rotation = self.sprite.rotation + self.speed
end

function Wheel:onInteract()
    self.speed = 0.3
end

return Wheel