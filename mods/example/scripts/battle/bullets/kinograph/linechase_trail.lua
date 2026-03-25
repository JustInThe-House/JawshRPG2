local LineChaseTrail, super = Class(Bullet)

function LineChaseTrail:init(x, y)
    super.init(self, x, y, "bullets/pixel")
    self:setScale(4)
    self:setColor(1,0,0,1)
    self.layer = BATTLE_LAYERS["below_bullets"]
    self.moving = false
end

function LineChaseTrail:onWaveSpawn(wave)
    self.wave.timer:after(0.5, function ()
        self.moving = true
        local soul = Game.battle.soul
        self.physics.direction = MathUtils.angle(self.x, self.y, soul.x, soul.y)
    end)
end

function LineChaseTrail:update()
    if self.moving then
        self.physics.speed = self.physics.speed + DT * 3
    end
    super.update(self)
end

return LineChaseTrail
