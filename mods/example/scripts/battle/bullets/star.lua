local Star, super = Class(Bullet)

function Star:init(x, y, dir, speed)
    super.init(self, x, y, "bullets/star_main"..math.random(1,3))
    self.physics.direction = dir
    self.physics.speed = speed
    self.scale = 0.2
    self.scaleup = 0
    self.scaleupfactor = MathUtils.random(0.1, 0.3)
    self.collider = CircleCollider(self, self.width / 2, self.height / 2, self.width / 4)
    self:setScale(self.scale, self.scale)
    self.remove_offscreen = true
    self.stop = false
    self.color = { 1, 1, 1 }
    self.explode = 0
    self.destroy_on_hit = false
    self.rand = MathUtils.random(0, 360)

    if Game.battle.encounter.difficulty <= 1 then
        self.mesh_color1, self.mesh_color2 = 1,1
        self.child_angle = { self.rand, self.rand + 60, self.rand + 120 }
    else
        self.mesh_color1, self.mesh_color2 = 0.8, 0
        self.child_angle = { self.rand }
    end

    self.timer_lightfx = 0

    self.mesh = love.graphics.newMesh({
                                          { 0,    0,   0, 0, self.mesh_color1, self.mesh_color2, self.mesh_color1, 1 },
                                          { 0.5,  1.0, 0, 0, self.mesh_color1, self.mesh_color2, self.mesh_color1, 0 },
                                          { -0.5, 1.0, 0, 0, self.mesh_color1, self.mesh_color2, self.mesh_color1, 0 },
                                      }, "fan", "dynamic"
    )
end

function Star:update()
    if self.physics.speed > 0 then
        self.scaleup = self.scaleup + DT * self.scaleupfactor
    else
        self.color = { math.max(self.color[1] - DT, 0.8), math.max(self.color[2] - 1.5 * DT, 0), math.max(
            self.color[3] - DT, 0.8) }
    end
    self:setScale(self.scale + self.scaleup, self.scale + self.scaleup)
    if self.stop then
        if self.physics.speed > 0 then
            self.physics.speed = self.physics.speed - 0.29 * DTMULT
        else
            self.physics.speed = self.physics.speed - 0.075 * DTMULT
            self.timer_lightfx = self.timer_lightfx + DT
        end
    end

    if self.explode > 0 then
        self.explode = self.explode + DT
    end
    if self.explode > 1 then
        self.startscale_x = self.scale_x
        local speed = 1.25 + self.scale_x + Game.battle.encounter.difficulty * 0.5
        
        local size = math.sqrt(self.scale_x*1.2)
        for child = 1, #self.child_angle do
            if Game.battle.encounter.difficulty == 0 then
                self.wave:spawnBullet("star_child", self.x, self.y, math.rad(self.child_angle[child]),
                                      speed * (1 - 0.5 * (child % 2)), size)
                self.wave:spawnBullet("star_child", self.x, self.y, math.rad(self.child_angle[child] + 180),
                                      speed * (1 - 0.5 * ((child + 1) % 2)), size)
            else
                self.wave:spawnBullet("star_child", self.x, self.y, math.rad(self.child_angle[child]), speed, size)
                self.wave:spawnBullet("star_child", self.x, self.y, math.rad(self.child_angle[child] + 180), speed, size)
            end
            if Game.battle.encounter.difficulty >= 2 then
                self.wave:spawnBullet("star_child_trail", self.x, self.y, math.rad(self.child_angle[child]), speed / 2)
                self.wave:spawnBullet("star_child_trail", self.x, self.y, math.rad(self.child_angle[child]), speed / 3)
                self.wave:spawnBullet("star_child_trail", self.x, self.y, math.rad(self.child_angle[child] + 180),
                    speed / 2)
                self.wave:spawnBullet("star_child_trail", self.x, self.y, math.rad(self.child_angle[child] + 180),
                    speed / 3)
            end
        end

        Assets.playSound("particle_explosion")
        self:setScale(1.5 * self.scale_x, 1.5 * self.scale_x)
        local after_image = AfterImage(self.sprite, 0.7)
        self.wave:addChild(after_image)
        self:remove()
    end


    super.update(self)
end

function Star:draw()
    if self.physics.speed <= 0 then
        love.graphics.setColor(1, 1, 1, 0.3 * self.timer_lightfx)
        local start_x, start_y = self.origin_x + self.width / 2, self.origin_y + self.height / 2
        local light_length = 100 * self.timer_lightfx
        local light_stretch = 4 * self.timer_lightfx
        for child = 1, #self.child_angle do
            love.graphics.draw(self.mesh, start_x, start_y, math.rad(self.child_angle[child] + 90), 30,
                               200 + 40 * math.sin(60 * self.timer_lightfx) -
                               ((Game.battle.encounter.difficulty == 0 and 120 * ((child + 1) % 2)) or 0))
            love.graphics.draw(self.mesh, start_x, start_y, math.rad(self.child_angle[child] + 90 + 180), 30,
                               200 + 40 * math.sin(60 * self.timer_lightfx) -
                               ((Game.battle.encounter.difficulty == 0 and 120 * (child % 2)) or 0))
        end
    end
    super.draw(self)
end

function Star:shouldSwoon(damage, target, soul)
    return true
end

function Star:onGraze(first)
    if first == true then
            self.wave.timer:after(0.1, function ()
        self.grazed = false
    end)
    end
end

function Star:getGrazeTension()
    return ((self.attacker and self.attacker:getGrazeTension()) or 1.6) / 4
end

return Star
