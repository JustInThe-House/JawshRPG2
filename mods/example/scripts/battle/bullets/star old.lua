-- this one chases player. made it feel kinda slow so i removed it. OG reverses speed
local Star, super = Class(Bullet)

function Star:init(x, y, dir, speed)
    super.init(self, x, y, "bullets/star_main")
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.scale = 0.3
    self.scaleup = 0
    self.scaleupfactor = Utils.random(0, 2.5 * DTMULT)
    self.collider = CircleCollider(self, self.width/2, self.height/2, self.width/4)
    self:setScale(self.scale, self.scale)
    self.remove_offscreen = true
    self.chase = false
    self.stop = false
    self.color = { 1, 1, 1 }
    self.explode = 0
    self.destroy_on_hit = false
    self.child_angle = Utils.random(0, 360)
end

function Star:update()
    if not self.chase then
        self.scaleup = self.scaleup + DTMULT * (1 + self.scaleupfactor) / 240
    else
        self.color = { math.max(self.color[1] - DT, 0.8), math.max(self.color[2] - 1.5 * DT, 0), math.max(
        self.color[3] - DT, 0.8) }
    end
    self:setScale(self.scale + self.scaleup, self.scale + self.scaleup)
    if self.stop then
        if self.physics.speed > 0 and not self.chase then
            self.physics.speed = self.physics.speed - 0.27 * DTMULT
        elseif self.physics.speed <= 0 and not self.chase then
            self.chase = true
            self.startscale_x = self.scale_x
            self.startscale_y = self.scale_y
        end
    end
    if self.chase then
        self.physics.direction = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
        self.physics.speed = self.physics.speed + 0.03 * DTMULT

        if self.explode > 0 then
            self.explode = self.explode + DT
        end
        if self.explode > 1 then
            local speed = 1.5 + self.scale_x + Game.battle.encounter.difficulty * 0.4
            local size = self.scale_x * 1.2
            if Game.battle.encounter.difficulty <= 1 then
                self.wave:spawnBullet("star_child", self.x, self.y, math.rad(30 + self.child_angle), speed, size)
                self.wave:spawnBullet("star_child", self.x, self.y, math.rad(150 + self.child_angle), speed, size)
                self.wave:spawnBullet("star_child", self.x, self.y, math.rad(270 + self.child_angle), speed, size)
                if Game.battle.encounter.difficulty == 0 then
                    self.wave:spawnBullet("star_child", self.x, self.y, math.rad(90 + self.child_angle), speed * 0.5,
                        size)
                    self.wave:spawnBullet("star_child", self.x, self.y, math.rad(210 + self.child_angle), speed * 0.5,
                        size)
                    self.wave:spawnBullet("star_child", self.x, self.y, math.rad(330 + self.child_angle), speed * 0.5,
                        size)
                else
                    self.wave:spawnBullet("star_child", self.x, self.y, math.rad(90 + self.child_angle), speed, size)
                    self.wave:spawnBullet("star_child", self.x, self.y, math.rad(210 + self.child_angle), speed, size)
                    self.wave:spawnBullet("star_child", self.x, self.y, math.rad(330 + self.child_angle), speed, size)
                end
            else
                self.wave:spawnBullet("star_child", self.x, self.y, math.rad(0 + self.child_angle), speed, size)
                self.wave:spawnBullet("star_child", self.x, self.y, math.rad(180 + self.child_angle), speed, size)
            end
            Assets.playSound("particle_explosion")
            self:setScale(1.5 * self.scale_x, 1.5 * self.scale_x)
            local after_image = AfterImage(self.sprite, 0.7)
            self.wave:addChild(after_image)
            self:remove()
        end
    end


    super.update(self)
end

function Star:shouldSwoon(damage, target, soul)
    return true
end

return Star
