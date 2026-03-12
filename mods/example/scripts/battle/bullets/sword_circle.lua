local sword_circle, super = Class(Bullet)

function sword_circle:init(x, y, dir, r, xstart, ystart)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/sword")
    -- self.physics.direction = dir having this gives it a cool rotating around effect
    self.rotation = dir
    self.physics.speed = 0
    self.inv_timer = 0.5
    --self.collider = Hitbox(self, 5, 14, self.width-7, 4) better hitbox for the moving ones
    self.collider = Hitbox(self, 5, self.height / 3, self.width - 7, self.height / 3)
    self.alpha = 0
    self.color = { 1, 1, 1 }
    self.timer_charge = 0
    self.remove_offscreen = true
    self.destroy_on_hit = false
    self.time_bonus = 0
    self.can_graze = false
    self.rotate = dir - math.pi / 2
    self.r = r
    self.test1 = 0
    self.start_x, self.start_y = Game.battle.arena.x + xstart, Game.battle.arena.y + ystart
    self.targeting = false
    self.pause = false

    self.targeting_init = false
    self.circle_rotate = 0
end

function sword_circle:update()
    self.timer_charge = self.timer_charge + DT
    if self.alpha < 1 then
        self.alpha = self.alpha + self.timer_charge
    end

    if not self.targeting then
        self.rotate = self.rotate + DT
        self.circle_rotate = self.circle_rotate + DT
        self.rotation = self.rotation + DT
        self.test1 = self.test1 + 2 * DT

        self.x = self.start_x + 20 * math.cos(self.circle_rotate / 2) +
            ((self.r + 10 * math.sin(self.test1)) * math.cos(self.rotate))
        self.y = self.start_y + 20 * math.sin(self.circle_rotate / 2) +
            ((self.r + 10 * math.sin(self.test1)) * math.sin(self.rotate))
    elseif self.targeting and not self.targeting_init then
        self.collider = nil
        self.physics.direction = self.rotation - math.pi / 2
        self.physics.speed = 3.5
        self.wave.timer:tween(0.65, self, { rotation = self.rotation + 10 * math.pi / 4 }, "out-quad", function()
            self:setColor(0.8, 0, 0.8)
            self.physics.match_rotation = true
            self.physics.speed = 50
        end)
        self.wave.timer:after(0.25, function()
            self.collider = Hitbox(self, 0, 14, self.width, 4)
        end)
        self.timer_afterimage = self.wave.timer:every(0.1, function()
            if self:isRemoved() then return false end
            local after_image2 = AfterImage(self.sprite, 0.4)
            self:addChild(after_image2)
        end)
        self.targeting_init = true
    end

    --[[if self.timer_charge >= self.limit and not self.fully_charged then
        self.pause = true
        self.after_image1 = AfterImage(self.sprite, 0.6)
        self:addChild(self.after_image1)
        self.after_image1:setScaleOriginExact(self.x,self.y)
        self.colormask = self:addFX(ColorMaskFX())
        self.fully_charged = true
    elseif self.timer_charge >= self.limit+3 and not self.attacking then
        self:removeFX(self.colormask)
        self.physics.speed = 130
        self:setColor(0.8,0,0.8)
        self.wave:spawnBulletTo(Game.battle.mask, "sword_trail", self.x, self.y, self.rotation, 130, "sword", {1,1,1})
        Assets.playSound("knight_cut1")
        Assets.playSound("soylent")
       -- self.wave:spawnBulletTo(Game.battle.mask, "sword_trail", self.x, self.y, self.rotation, 130, "box")
       self.can_graze = true
       self.pause = false
       self.attacking = true
    end

    if self.timer_charge > self.limit + 3 then
        local after_image2 = AfterImage(self.sprite, 0.4)
        self:addChild(after_image2)
    end
    if self.pause then
        self.after_image1:setScale(1+(self.timer_charge-self.limit)*DTMULT/2,1+(self.timer_charge-self.limit)*DTMULT/2)
    end]]
    super.update(self)
end

function sword_circle:shouldSwoon(damage, target, soul)
    return true
end

return sword_circle
