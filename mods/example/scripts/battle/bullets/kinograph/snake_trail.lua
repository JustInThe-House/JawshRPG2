local SnakeTrail, super = Class(Bullet)

function SnakeTrail:init(x, y)
    super.init(self, x, y, "bullets/pixel")
    self:setScale(4)
    self:setColor(1,0,0,1)
    self.layer = BATTLE_LAYERS["below_bullets"]
    self.tp = 0.4
end

return SnakeTrail
