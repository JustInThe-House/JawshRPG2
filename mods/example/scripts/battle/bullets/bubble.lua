local Bubble, super = Class(Bullet)

function Bubble:init(x, y, dir, speed, gravity)
    super.init(self, x, y, "bullets/minecraft_bubble/bubble")

    self.collider = CircleCollider(self, self.width / 2, self.height / 2, 2.5)
    self.rotation = 0
    self.physics.direction = dir

    self.physics.speed = speed
    self.physics.gravity = 0.3
    self.physics.gravity_direction = gravity
    self:setScale(2, 2)
    self.remove_offscreen = false
    self.jiggle_scale = 0
end

function Bubble:onWaveSpawn(wave)
    self.wave.timer:after(MathUtils.random(0.5, 1.25), function()
        self.pop_timer = self.wave.timer:tween(0.9, self, { jiggle_scale = 6 * math.pi }, "out-elastic", function()
            self.wave:spawnBullet("bubble_child", self.x, self.y, 0, 9)
            self.wave:spawnBullet("bubble_child", self.x, self.y, math.pi, 9)
            self.collidable = false
            self:setSprite("bullets/minecraft_bubble/bubble_pop", 0.01, false, function()
                Assets.playSound("minecraft/bubble_pop", 1, MathUtils.random(0.9, 1.1))
                self:remove()
            end)
        end)
    end)
end

function Bubble:onRemove(parent)
    if self.pop_timer ~= nil then
        self.wave.timer:cancel(self.pop_timer)
    end
end

function Bubble:update()
    self:setScale(1.5 + 0.5 * math.cos(self.jiggle_scale), 1.5 + 0.5 * (1 - math.sin(self.jiggle_scale)))
    super.update(self)
end

return Bubble
