local SmokeFog, super = Class(Bullet)

function SmokeFog:init(x, y)
    super.init(self, x, y, "particles/minecraft_smoke")

    self.collidable = false
    self:setScale(6)
    self.alpha = 0
    self.siner = MathUtils.random(0,2*math.pi)
end

function SmokeFog:onWaveSpawn(wave)
    self:fadeTo(0.85, MathUtils.random(0.8,1.5))
end

function SmokeFog:update()
    self.siner = self.siner + DT
    self.x = self.x + math.cos(self.siner)
    super.update(self)
end

return SmokeFog
