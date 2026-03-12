local star_child, super = Class(Bullet)

function star_child:init(x, y, dir, speed, scale)
    super.init(self, x, y, "bullets/star_child")
    self.rotation = dir
    self.physics.match_rotation = true
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.start_speed = speed
    self.collider = Hitbox(self, self.width / 5, self.height / 3, self.width / 3, self.height / 3)
    self:setScale(scale, scale)
    self.base_scale = scale
    self.destroy_on_hit = true
    self.sprite.anim_speed = 3
    self.chasing = false
    self.color = { 1, 1, 1 }

    self.charging = false
    self.flip_angle = 0
end

function star_child:onWaveSpawn(wave)
    local timer_denominator = 1.7
    if Game.battle.encounter.difficulty >= 2 then
        timer_denominator = 2.2
    end
    self.wave.timer:tween(self.start_speed / timer_denominator, self.physics, { speed = 0.5 }, "in-quad")
    self.wave.timer:after(self.start_speed / timer_denominator, function()
        if Game.battle.encounter.difficulty <= 1 then
            self:fadeOutAndRemove(0.8)
        else
            self.wave.timer:after(2 ^ (-self.x / 120), function()
                self.physics.match_rotation = false
                self.soul_x, self.soul_y = Game.battle.soul.x, Game.battle.soul.y
                self.start_x, self.start_y = self.x, self.y
                self.angle_fixed = Utils.angle(self, Game.battle.soul)
                self.physics.direction = self.angle_fixed
                self.flips = TableUtils.pick({ 1, 3 })
                self.sprite.anim_speed = 4
                self.chasing = true
                self.outline = self:addFX(OutlineFX({ 0.8, 0, 0.8 }))
                self.outline.thickness = 2
                self.collider = nil

                self.wave.timer:tween(math.sqrt(self.flips) / 4, self, { flip_angle = (2 * math.pi * self.flips) })

                self.wave.timer:tween(math.sqrt(self.flips) / 4, self.physics, { speed = -2 }, "out-quad", function()
                    self.collider = Hitbox(self, self.width / 5, self.height / 3, self.width / 3, self.height / 3)
                    self.charging = true

                    self.wave.timer:tween(1, self.physics, { speed = 16 }, "in-back")
                    --self.wave.timer:tween(3.5, self, { scale_x = self.scale_x + 0.4 }, "in-quad")

        self.timer_afterimage = self.wave.timer:every(0.1, function()
            if self:isRemoved() then return false end
            local after_image2 = AfterImage(self.sprite, 0.4)
            self:addChild(after_image2)
        end)
                end)
                self.wave.timer:tween(math.sqrt(self.flips) / 4.5, self, { rotation = self.angle_fixed })
            end)
        end
    end)
end

function star_child:update()
    if Game.battle.encounter.difficulty >= 2 and self.chasing then
        if not self.charging then
            self.scale_y = self.base_scale * math.cos(self.flip_angle+ math.pi)
        end
        self:setColor(0.8 * math.cos(self.flip_angle + math.pi), 0, 0.8 * math.cos(self.flip_angle + math.pi))

        if self.scale_y > 0 then
            --    self:setSprite("bullets/star_child_1") -- alternative way by changing sprite. may actually use this
        else
            --      self:setSprite("bullets/star_child_inv")
        end
    end
    super.update(self)
end

function star_child:shouldSwoon(damage, target, soul)
    return true
end

function star_child:getGrazeTension()
    return ((self.attacker and self.attacker:getGrazeTension()) or 1.6) / 2
end

return star_child
