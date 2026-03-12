local Sword, super = Class(Bullet)

function Sword:init(x, y, dir, speed, r, rotloc, rmove, chargetype)
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
    self.chargeup = 0
    self.remove_offscreen = true
    self.timer_charge = chargetype
    self.destroy_on_hit = false
    self.time_bonus = 0
    self.can_graze = false
    self.pause = false
    if self.timer_charge == "fast" then
        self.limit = 13
    else
        self.limit = 27
    end
    self.rotate = 0
    self.r = r
    self.rotloc = rotloc
    if Game.battle.encounter.difficulty == 0 then
        self.rotdir = 1
    else
        self.rotdir = TableUtils.pick({ -1, 1 })
        -- if i want static swords, include 0
        -- if i want more diverse movements, make it a range between -1 and 1
    end
    self.rmove = rmove
    self.fully_charged = false
    self.attacking = false
end

function Sword:update()
    self.chargeup = self.chargeup + DTMULT
    --   self:setScale(1,math.cos((self.chargeup/20)*math.pi))--- LITERALLY THIS IS ALL YOU NEED TO DO TO GET THE COOL FLIPPING OF THE STARS. AND THIS WAS ALSO DONE TO THE COLOR TRANSITION TO MAKE IT LOOK LIKE IT WAS FLIPPING
    --  self:setColor(1-math.cos((self.chargeup/20)*math.pi),0,0) -- THIS IS WHAT I MEANT WITH THE COLORS
    -- you can also then increase y scale and decrease xscale to make it look like it is moving faster (stretching due to speed)
    -- THIS IS ALSO PROBABLY HOW JEVIL'S CAROUSEL WORKS TOO

    if self.chargeup <= self.limit then
        self:setColor(1 - (0.2 * self.chargeup / self.limit), 1 - self.chargeup / self.limit,
                      1 - (0.2 * self.chargeup / self.limit))
        self.rotate = self.rotate + 3 * DTMULT
        self.x = Game.battle.soul.x +
            (self.r + math.sqrt(1 - (1 - (math.abs(self.limit - self.chargeup) / self.limit) - 1) ^ 2) * self.rmove) *
            math.sin(math.rad(self.rotloc + self.rotdir * self.rotate))
        self.y = Game.battle.soul.y +
            (self.r + math.sqrt(1 - (1 - (math.abs(self.limit - self.chargeup) / self.limit) - 1) ^ 2) * self.rmove) *
            math.cos(math.rad(self.rotloc + self.rotdir * self.rotate))
        self.rotation = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
    end

    if self.chargeup >= self.limit and not self.fully_charged then
        self.pause = true
        self.after_image1 = AfterImage(self.sprite, 0.6)
        self:addChild(self.after_image1)
        self.after_image1:setScaleOriginExact(self.x, self.y)
        self.colormask = self:addFX(ColorMaskFX())
        self.wave.timer:tween(0.1, self.after_image1, { scale_x = self.scale_x * 1.5, scale_y = self.scale_y * 1.5 },
                              "linear", function()
                                  self.after_image1:fadeOutAndRemove(0.25)
                              end)
        self.fully_charged = true
    elseif self.chargeup >= self.limit + 3 and not self.attacking then
        self:removeFX(self.colormask)
        self.physics.speed = 130
        self:setColor(0.8, 0, 0.8)
        self.wave:spawnBulletTo(Game.battle.mask, "sword_trail", self.x, self.y, self.rotation, 130, "sword", { 1, 1, 1 })
        Assets.playSound("knight_cut1")
        Assets.playSound("soylent")
        self.can_graze = true
        self.pause = false
        self.timer_afterimage = self.wave.timer:every(0.1, function()
            if self:isRemoved() then return false end
            local after_image2 = AfterImage(self.sprite, 0.4)
            self:addChild(after_image2)
        end)
        self.attacking = true
    end
    super.update(self)
end

function Sword:shouldSwoon(damage, target, soul)
    return true
end

function Sword:getGrazeTension()
    return ((self.attacker and self.attacker:getGrazeTension()) or 1.6) * 1.5
end

return Sword
