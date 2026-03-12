local MusketShot, super = Class(Object)

function MusketShot:init()
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    self.targets = {}
    self.hit = {}
    self.updated_once = false
    self.state = "INIT"
    self.layer = BATTLE_LAYERS["above_ui"]
    self.draw_children_above = 10
    self.debug_select = false
    self.siner_x = 0
        self.siner_y = 0
    self.siner_speed_x = MathUtils.random(3.5, 4.5)
    self.siner_speed_y = MathUtils.random(5.5, 6.5)
    self.afterimg_timer = 0
end

function MusketShot:setup()
    self.crosshair = Sprite("effects/target", SCREEN_WIDTH - 50, SCREEN_HEIGHT / 3)
    self:addChild(self.crosshair)

    for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
        local target_x, target_y = enemy:getRelativePos(0, 0, Game.battle)
        local target = MusketTarget(target_x, target_y, enemy.width, enemy.height)
        self:addChild(target)
        target.target = enemy
        table.insert(self.targets, target)
    end
    self.state = "WAIT"
end

function MusketShot:shoot()
    self.bullet = Sprite("bullets/smallbullet", 170, 170)
    self.bullet.physics.direction = Utils.angle(self.bullet, self.crosshair)
    self.bullet.physics.speed = 50
    self.bullet:setHitbox(0, 0, 8,8)
    self:addChild(self.bullet)
    self.state = "SHOOT"
    return function() return self.state == "DONE", self.hit end
end

function MusketShot:update()
    self.updated_once = true
    if self.state == "WAIT" then
        self.siner_x = self.siner_x + DT * self.siner_speed_x
                self.siner_y = self.siner_y + DT * self.siner_speed_y
        self.crosshair.y = 155 + (SCREEN_HEIGHT / 3) * math.sin(self.siner_y)
        self.crosshair.x = 550 + (SCREEN_WIDTH / 8) * math.sin(self.siner_x)
    elseif self.state == "SHOOT" then
        self.afterimg_timer = self.afterimg_timer + DT
        if self.afterimg_timer >= 0.01 then
            self.afterimg_timer = 0
            local after_image = AfterImage(self.bullet, 0.4)
            Game.battle:addChild(after_image)
        end
        for _, target in ipairs(self.targets) do
            if self.bullet:collidesWith(target) then
                table.insert(self.hit, target.target)
                self.bullet:remove()
                self.state = "DONE"
            end
        end
        if self.bullet.x > SCREEN_WIDTH then
            self.bullet:remove()
            self.state = "DONE"
        end
    end
    super.update(self)
end

return MusketShot
