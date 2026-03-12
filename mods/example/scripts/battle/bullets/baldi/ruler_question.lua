local Ruler, super = Class(Bullet)

function Ruler:init(x, y, dir)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/ruler")
    self.rotation = dir
    self.collider = Hitbox(self, 0, 0, self.width, self.height)
    self.physics.speed = 0
    self.destroy_on_hit = false
    self.inv_timer = 2
    self:setScale(2*2.5, 5*2)
    self:setOrigin(0.5,1)
end

function Ruler:onWaveSpawn(wave)
    self.damage = (self.attacker and self.attacker.attack * 8) or 1
end

return Ruler
