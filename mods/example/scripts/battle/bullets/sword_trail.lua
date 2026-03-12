local sword_trail, super = Class(Bullet)

function sword_trail:init(x, y, dir, speed, type, color)
    super.init(self, x, y, "bullets/sword_trail")
    self.graphics.remove_shrunk = true
    self.rotation = dir
    self.physics.match_rotation = true
    self.physics.speed = speed
    self.collider = nil
    self.remove_offscreen = true
    self.destroy_on_hit = false
    self.timer = 0
    self.type = type
    self.can_graze = false
    self.color = color
end

function sword_trail:onWaveSpawn(wave)
        if self.type == "slash" then
        self.rotation_finish = self.rotation
        if Game.battle.encounter.difficulty <= 2 then
            self.rotation = self.rotation + TableUtils.pick({ -1, 1 }) * MathUtils.random(math.pi / 12, math.pi / 8)
        else
            self.rotation = self.rotation + TableUtils.pick({ -1, 1 }) * MathUtils.random(math.pi / 12, math.pi / 4)
        end
        self.scale_y = 5
        self.wave.timer:tween(26 / 30, self, { rotation = self.rotation_finish }, "in-quad")
        self.wave.timer:tween(0.3, self, { scale_x = 8.5 })
        self.wave.timer:tween(26 / 30, self, { scale_y = -0.1 })
    end
end

function sword_trail:update()
    self.timer = self.timer + DTMULT

    if self.type == "sword" then
        --    self.layer = BATTLE_LAYERS["below_arena"] + 15
        self:setScale(self.timer * 3, self.timer / 2)
    elseif self.type == "box" then
        --    self.layer = BATTLE_LAYERS["arena"] + 10 --  BATTLE_LAYERS["arena"] gives it a really cool follow line trail effect (assuming you dont mask it)
        self.remove_offscreen = false
        self.collider = Hitbox(self, 0, 0, self.width, self.height)
        self.can_graze = true
        self:setScale(math.min(self.timer * 3, 3), math.max(1, 1.1 * self.timer))
    elseif self.type == "boxcut" then
        self.inv_timer = 0.25
        self.remove_offscreen = false
        self.collider = Hitbox(self, 0, 0, self.width, self.height)
        self:setScale(3 * self.timer, math.max(0, 3 - self.timer))
    end
    if self.timer > 60 then
        self:remove()
    end
    super.update(self)
end

function sword_trail:shouldSwoon(damage, target, soul)
    return true
end

return sword_trail
