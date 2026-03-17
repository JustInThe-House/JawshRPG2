local Mine, super = Class(Wave)
-- jump at box, "mine" with pickaxe, drag outward, leaving a solid green line (border). use solids
-- borders are good just being added. instead, will add "blocks" taht move upward then fall with gravity. a few spawn on impact, and a couple spawn while on drag
function Mine:init()
    super.init(self)

    self.time = 8
    self.shaking = false
    self.solids = {}
    self.happyguy = Game.battle:getEnemyBattler("happyguy")

    --  self.timer:tween(0.35, Game.battle:getEnemyBattler("soyingjawsh").arm, { rotation = 0 },"out-quad")
end

function Mine:onStart()
    self.happyguy.layer = BATTLE_LAYERS["above_bullets"]
    self.attackers = self:getAttackers()

    self.hitbox_invisible = self:spawnBullet("happyguy_invisible", self.happyguy.x,
                                             self.happyguy.y)
    self.happyguy:setAnimation("jump")
    self.happyguy:slideTo(self.happyguy.target_x - 40,
                          self.happyguy.target_y - 220, 0.4,
                          "outQuad")
    Assets.playSound("jump", 1, 1)


    self.timer:every(1.3, function()
        for _, attacker in ipairs(self.attackers) do
            local start_direction = TableUtils.pick({ "left", "right" })
            local start_location = SCREEN_WIDTH + 40
            Kristal.Console:log(self.happyguy.scale_x)
            self.happyguy:setAnimation("jump")
            self.happyguy.scale_x = 2
            self.happyguy.physics.direction = math.rad(220)

            if start_direction == "left" then
                start_location = 0 - 40
                self.happyguy.scale_x = -2
                self.happyguy.physics.direction = math.rad(320)
            end
            Assets.playSound("jump", 1, 1)
            self.happyguy:setPosition(start_location, 220 + MathUtils.random(0, 30))
            self.happyguy.physics.gravity_direction = math.pi / 2
            self.happyguy.physics.gravity = 1.2

            self.happyguy.physics.speed = MathUtils.random(22, 26)
            self.timer:after(0.7, function()
                Assets.playSound("minecraft/stone_mine", 2.2)
                self.happyguy:setAnimation("mine")
                self.happyguy.physics.gravity_direction = 0
                self.happyguy.physics.gravity = 0
                self.happyguy.physics.speed = 0
                self.happyguy.physics.direction = self.happyguy
                    .physics.direction
                self.timer:tween(0.5, self.happyguy.physics, { speed = -30 }, "linear")
                Game.battle.arena:shake(TableUtils.pick({ -3, 3 }), TableUtils.pick({ -3, 3 }), 0, 2 / 30)
                self.timer:after(0.2, function()
                    Game.battle.arena:stopShake()
                end)
                local x, y = attacker:getRelativePos((attacker.width / 2),
                                                     (attacker.height / 2))
                local pitch_up = 0
                for i = 1, 6 do
                    self:spawnBullet("gravityblock", x, y,
                                     -math.pi / 2 + MathUtils.random(-math.pi / 6, math.pi / 6),
                                     MathUtils.random(11, 13))
                end
                --[[local solidx, solidy = attacker:getRelativePos((attacker.width / 2),
                                                               (attacker.height / 2))
                self.solid = Solid(true, solidx, solidy, 50, 5)
                self.solid.rotation = self.happyguy.physics.direction
                table.insert(self.solids, self.solid)
                Game.battle:addChild(self.solid)]]

                self.timer:every(0.1, function()
                                     x, y = attacker:getRelativePos((attacker.width / 2),
                                                                    (attacker.height / 2))
                                     self:spawnBullet("gravityblock", x, y,
                                                      -math.pi / 2 + MathUtils.random(-math.pi / 6, math.pi / 6),
                                                      MathUtils.random(6, 8))
                                     Assets.playSound("minecraft/stonecutter", 1, 1 + pitch_up / 5)
                                     pitch_up = pitch_up + 1
                                 end, 4)
            end)
        end
    end)
end

function Mine:update()
    self.hitbox_invisible:setPosition(self.happyguy.x,
                                      self.happyguy.y)
    if MathUtils.sign(self.hitbox_invisible.scale_x) ~= MathUtils.sign(self.happyguy.scale_x) then
        self.hitbox_invisible.scale_x = -self.hitbox_invisible.scale_x
    end
    super.update(self)
end

function Mine:onEnd()
    self.happyguy:setAnimation(self.happyguy.reset_sprite)
    self.happyguy.physics.gravity_direction = 0
    self.happyguy.physics.gravity = 0
    self.happyguy.physics.speed = 0
    self.happyguy.layer = BATTLE_LAYERS["battlers"]
    self.happyguy.scale_x = 2
    self.happyguy:slideTo(self.happyguy.target_x,
                          self.happyguy.target_y, 0.5)

    --[[for _, solid in ipairs(self.solids) do
        solid:remove()
    end]]
end

return Mine
