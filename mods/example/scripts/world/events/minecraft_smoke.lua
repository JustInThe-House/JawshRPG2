local Smoke, super = Class(Event, "minecraft_smoke")

function Smoke:init(data)
    super.init(self, data.x, data.y, 20, 20, data)

    self:setScale(16)

    self:setOrigin(0.5, 0.5)
    self.siner = MathUtils.random(0, 2 * math.pi)
    self.speed = 0
    self.angle = MathUtils.random(0, 2 * math.pi)
end

function Smoke:update()
    super.update(self)
    self.siner = self.siner + DT

    if Game:getFlag("minecraft_smoke_airout", false) then
        self.speed = self.speed + 30 * DT
        self.alpha = 1 - self.speed / 40
        if self.speed > 40 then
            self:remove()
        end
    end
end

function Smoke:draw()
    love.graphics.setBlendMode("subtract")
    love.graphics.setColor(1,1,1,0.5)
    love.graphics.draw(Assets.getTexture("particles/minecraft_smoke"),
        0 + 2 * math.cos(self.siner) + self.speed * math.cos(self.angle), 0 + self.speed * math.sin(self.angle))
    super.draw(self)
    love.graphics.setBlendMode("alpha")
end

return Smoke
