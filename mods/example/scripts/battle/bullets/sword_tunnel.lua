local sword_tunnel, super = Class(Bullet)

function sword_tunnel:init(x, y, dir, speed, rot)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/sword_tunnel")
    self.physics.direction = dir
    self.physics.speed = speed
    self.start_speed = speed
    self.inv_timer = 0.25
    self.collider = Hitbox(self, 0, self.height / 3, self.width - 3, self.height / 3)
    self.rotation = rot
    self.rotation_type = rot
    self.chargeup = 0
    self.remove_offscreen = false
    self.destroy_on_hit = false
    self:setScale(1, 0.1)
    self.retarget = false
    self.retarget_init = false
    self.start_x, self.start_y = 0, 0
    self.lines_color = 0
end

function sword_tunnel:onWaveSpawn(wave)
    self.tweenscale = self.wave.timer:tween(0.9, self, { scale_y = 1.15 }, "out-quad")
    self.tweenspeed = self.wave.timer:tween(0.9, self.physics, { speed = MathUtils.random(60, 70) }, "linear", function()
        --       self.tweenspeed = self.wave.timer:tween(0.9, self.physics, {speed = 0}, "linear", function ()
        self:remove()
    end)
end

function sword_tunnel:update()
    if not self.retarget then
        if self.rotation_type == math.pi / 2 or self.rotation_type == -math.pi / 2 then
            if math.abs(self.y - Game.battle.soul.y) < 75 and math.abs(self.x - Game.battle.soul.x) < 140 then
                self.color = { 0.8, 0, 0.8 }
            elseif math.abs(self.x - Game.battle.soul.x) >= 140 then
                self.color = { 1, 1, 1 }
            end
        elseif self.rotation_type == math.pi or self.rotation_type == 0 then
            if math.abs(self.x - Game.battle.soul.x) < 75 and math.abs(self.y - Game.battle.soul.y) < 140 then
                self.color = { 0.8, 0, 0.8 }
            elseif math.abs(self.y - Game.battle.soul.y) >= 140 then
                self.color = { 1, 1, 1 }
            end
        else
            if math.abs(self.x - Game.battle.soul.x) + math.abs(self.y - Game.battle.soul.y) < 150 then
                self.color = { 0.8, 0, 0.8 }
            else
                self.color = { 1, 1, 1 }
            end
        end


        local testssf = Utils.angle(self, Game.battle.soul)
        --Kristal.Console:log(Utils.dump({ testssf, self.rotation, testssf < -math.pi + (math.pi / 3) or
        --testssf > math.pi - (math.pi / 3) })) -- somehow these were causing the crashes??? no idea how tbh. amybe too many at once?
    else
        if not self.retarget_init then
            self.color = { 1, 1, 1 }
            self.physics.speed = 0
            self.wave.timer:cancel(self.tweenscale)
            self.wave.timer:cancel(self.tweenspeed)
            --self.collider = Hitbox(self, 0, (self.height / 2) - 3, self.width - 3, 6) --manually set hitbox size not based on len, width
            --local soul_angle = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
            local soul_angle = Utils.angle(self, Game.battle.soul)
            self.physics.direction = soul_angle
            self.wave.timer:tween(0.3, self.physics, { speed = -3 }, "linear", function()
                self.physics.speed = 0
            end)

            --Kristal.Console:log(Utils.dump({ soul_angle, soul_angle < math.pi / 2 + (math.pi / 3) and
            --soul_angle > math.pi / 2 - (math.pi / 3) })) -- somehow these were causing the crashes??? no idea how tbh

            -- garbage hardcode... angles suc
            if self.rotation_type == math.pi / 2 then
                if soul_angle < math.pi / 2 + (math.pi / 3) and soul_angle > math.pi / 2 - (math.pi / 3) then
                    self.angle_target = soul_angle
                else
                    self.angle_target = self.rotation +
                        MathUtils.sign(soul_angle - math.pi / 2) * math.pi / 3
                end
            elseif self.rotation_type == -math.pi / 2 then
                if -soul_angle < math.pi / 2 + (math.pi / 3) and -soul_angle > math.pi / 2 - (math.pi / 3) then
                    self.angle_target = soul_angle
                else
                    self.angle_target = self.rotation -
                        MathUtils.sign(-soul_angle - math.pi / 2) * math.pi / 3
                end
            elseif self.rotation_type == 0 then
                if soul_angle < 0 + (math.pi / 3) and soul_angle > 0 - (math.pi / 3) then
                    self.angle_target = soul_angle
                else
                    self.angle_target = self.rotation +
                        MathUtils.sign(soul_angle - 0) * math.pi /
                        3
                end
            elseif self.rotation_type == math.pi then
                if soul_angle < -math.pi + (math.pi / 3) or soul_angle > math.pi - (math.pi / 3) then
                    if MathUtils.sign(soul_angle) ~= MathUtils.sign(self.rotation) then
                        soul_angle = soul_angle + 2 * math.pi
                    end
                    self.angle_target = soul_angle
                else
                    self.angle_target = self.rotation -
                        MathUtils.sign(soul_angle - 0) * math.pi / 3
                end
            end
            --self.angle_target = soul_angle
            -- self.wave.timer:tween(0.4, self.physics, {speed = math.random(10,20)},"linear")
            self.wave.timer:tween(0.4, self, { rotation = self.angle_target })
            self.wave.timer:after(0.7, function()
                self.physics.match_rotation = true
                self.wave.timer:tween(0.25, self.physics, { speed = -6 }, "out-quad")
                self.wave.timer:after(0.25, function()
                    self.wave.timer:tween(0.3, self.physics, { speed = 110 }, "out-quad") --og is 60
                    local after_image = AfterImage(self.sprite, 0.7)
                    -- after_image:setScaleOrigin(0.5,0.5) -- mayb need fix, since not symmetric?
                    --maybe setup afterimage like teleport pearl, or how the example does it
                    after_image:setScale(1.5 * self.scale_x, 1.5 * self.scale_x)
                    self.wave:addChild(after_image)
                end)
            end)
            self.wave.timer:tween(0.4, self, { lines_color = 0.4 })

            self.timer_afterimage = self.wave.timer:every(0.1, function()
                if self:isRemoved() then return false end
                local after_image2 = AfterImage(self.sprite, 0.4)
                self:addChild(after_image2)
            end)
            self.retarget_init = true
        end
    end
    super.update(self)
end

function sword_tunnel:shouldSwoon(damage, target, soul)
    return true
end

function sword_tunnel:getGrazeTension()
    return ((self.attacker and self.attacker:getGrazeTension()) or 1.6) / 4
end

function sword_tunnel:draw()
    if self.retarget_init then
        love.graphics.setColor(0.8, 0, 0.8, self.lines_color)
        self.start_x, self.start_y = self.origin_x + self.width / 2, self.origin_y + self.height / 2
        love.graphics.line(self.start_x, self.start_y, self.start_x + 800,
                           self.start_y)
    end
    super.draw(self)
end

return sword_tunnel
