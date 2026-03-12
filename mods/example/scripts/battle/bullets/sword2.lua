local sword2, super = Class(Bullet)

function sword2:init(x, y, dir, speed, rotmove)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/sword")
    self.physics.direction = dir
    self.rotation = dir
    self.physics.match_rotation = true
    self.physics.speed = speed
    self.inv_timer = 0.25
    self.collider = Hitbox(self, 0, 14, self.width, 4)
    self.alpha = 1
    self.color = { 1, 1, 1 }
    self.timer_charge = 0
    self.rotate = 0
    self.rotmove = rotmove
    self.x = x
    self.y = y
    self.destroy_on_hit = false
    self.time_bonus = 0
    self.limit = 18

    self.fully_charged = false
    self.attacking = false
end

function sword2:update()
    self.timer_charge = self.timer_charge + DTMULT
    if self.timer_charge <= self.limit then
        self:setColor(1 - (0.2 * self.timer_charge / self.limit), 1 - self.timer_charge / self.limit,
            1 - (0.2 * self.timer_charge / self.limit))
        self.rotate = self.rotate + 0.025 * DTMULT
        self.x = self.x + (math.sqrt(1 - (self.rotate - 1) ^ 2)) * math.sin(self.rotmove) * DTMULT
        self.y = self.y + (math.sqrt(1 - (self.rotate - 1) ^ 2)) * math.cos(self.rotmove) * DTMULT
    end

    if self.timer_charge >= self.limit and not self.fully_charged then
        self.pause = true
        self.after_image1 = AfterImage(self.sprite, 0.6)
        self:addChild(self.after_image1)
        self.after_image1:setScaleOriginExact(self.x, self.y)
        self.colormask = self:addFX(ColorMaskFX())
        self.fully_charged = true
    elseif self.timer_charge >= self.limit + 3 and not self.attacking then
        self:removeFX(self.colormask)
        self.physics.speed = 130
        self:setColor(0.8, 0, 0.8)
        self.wave:spawnBulletTo(Game.battle.mask, "sword_trail", self.x, self.y, self.rotation, 130, "sword", { 1, 1, 1 })
        Assets.playSound("knight_cut1")
        Assets.playSound("soy", 0.5, 1.1)
        self.can_graze = true
        self.pause = false
        self.timer_afterimage = self.wave.timer:every(0.1, function()
            if self:isRemoved() then return false end
            local after_image2 = AfterImage(self.sprite, 0.4)
            self:addChild(after_image2)
        end)
        self.attacking = true
    end
    if self.pause then
        self.after_image1:setScale(1 + (self.timer_charge - self.limit) * DTMULT / 2,
            1 + (self.timer_charge - self.limit) * DTMULT / 2)
    end
    super.update(self)
end

function sword2:shouldSwoon(damage, target, soul)
    return true
end

function sword2:getGrazeTension()
    return ((self.attacker and self.attacker:getGrazeTension()) or 1.6) * 1.5
end

return sword2
