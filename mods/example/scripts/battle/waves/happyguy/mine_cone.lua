local MineCone, super = Class(Wave)
function MineCone:init()
    super.init(self)

    self.time = 8
    self.shaking = false
    self.happyguy = Game.battle:getEnemyBattler("happyguy")
   Game.battle.encounter.difficulty = 2
end

function MineCone:onStart()
    self.happyguy.layer = BATTLE_LAYERS["above_bullets"]
    self.attackers = self:getAttackers()
    self.happyguy:setAnimation("jump")
    self.happyguy:slideTo(self.happyguy.target_x - 40,
                          self.happyguy.target_y - 220, 0.4,
                          "outQuad")
    Assets.playSound("jump", 1, 1)

    self.timer:every(Game.battle.encounter.difficulty >= 2 and 0.95 or 1, function()
        for _, attacker in ipairs(self.attackers) do
            local start_direction = TableUtils.pick({ "left", "right" })
            local start_location = SCREEN_WIDTH + 40
            self.happyguy:setAnimation("jump")
            self.happyguy.scale_x = 2
            self.happyguy.physics.direction = math.rad(220)

            if start_direction == "left" then
                start_location = 0 - 40
                self.happyguy.scale_x = -2
                self.happyguy.physics.direction = math.rad(320)
            end
            Assets.playSound("jump", 1, 1)
            self.happyguy:setPosition(start_location, 180 + MathUtils.random(0, 70))
            self.happyguy.physics.gravity_direction = math.pi / 2
            self.happyguy.physics.gravity = 1.2

            self.happyguy.physics.speed = MathUtils.random(14, 18)
            self.timer:after(0.5, function()
                Assets.playSound("minecraft/stone_mine", 2.2)
                self.happyguy:setAnimation("mine")
                self.happyguy.physics.gravity_direction = 0
                self.happyguy.physics.gravity = 0
                self.happyguy.physics.speed = 0
                self.happyguy.physics.direction = self.happyguy
                    .physics.direction
                self.timer:tween(0.3, self.happyguy.physics, { speed = -30 }, "linear")
                local x, y = attacker:getRelativePos((attacker.width / 2), (attacker.height / 2))
                local rand = MathUtils.random(-math.pi / 12, math.pi / 12)
                local angle = MathUtils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)
                local gravity = Game.battle.encounter.difficulty >= 1 and TableUtils.pick({-1,1}) or 1
                for i = 1, 5 do
                    self:spawnBullet("stone_out", x, y, angle + rand + math.rad(15 * i - 45), 5.5, gravity)
                end
            end)
        end
    end)
end

function MineCone:onEnd()
    self.happyguy:setAnimation(self.happyguy.reset_sprite)
    self.happyguy.physics.gravity_direction = 0
    self.happyguy.physics.gravity = 0
    self.happyguy.physics.speed = 0
    self.happyguy.layer = BATTLE_LAYERS["battlers"]
    self.happyguy.scale_x = 2
    self.happyguy:slideTo(self.happyguy.target_x, self.happyguy.target_y, 0.5)
end

return MineCone
