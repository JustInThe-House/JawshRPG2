local Ruler, super = Class(Bullet)

function Ruler:init(x, y, dir)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/ruler")
    self.rotation = dir
    self.physics.match_rotation = true
    self.collider = Hitbox(self, 0, 0, self.width, self.height)
    self.physics.speed = 0
    self.collidable = false
    self.destroy_on_hit = false
    self:setScaleOrigin(0.5, 1)
    self:setScale(0.1, 2)

    --[[self:setShearOrigin(0, 1)
    local soul = Game.battle.soul
    local angle = MathUtils.angle(x, y, soul.x, soul.y)
    self:setShear(math.cos(angle), math.sin(angle))]]
end

function Ruler:onWaveSpawn(wave)
    local time_drop = 0.5
    local time_remove = time_drop + 0.8
    --  self.wave.timer:tween(time_drop, self, {shear_y = 0}, "in-quad")

    self.wave.timer:after(0.2, function()
        self.wave.timer:tween(time_drop, self, { scale_x = 2.5, scale_origin_x = 0 }, "linear", function ()
            Assets.playSound("ruler_slap", 1)
        end)
        self.wave.timer:after(time_drop - 0.05, function()
            self.collidable = true
        end)
    end)

    self.wave.timer:after(time_remove, function()
        self.collidable = false
        self:fadeOutAndRemove(0.3)
    end)
end

return Ruler
