local tunnel_cardinal, super = Class(Wave)
function tunnel_cardinal:init()
    super.init(self)
    self:setArenaSize(213, 142)
    self.time = 11
    self.timer_rate = 0
    self.spawn_x1 = SCREEN_WIDTH
    self.spawn_y2 = -10
    self.cooldown =0.12
    self.siner = 0
    Game.battle.encounter.difficulty =2 
    self.rand_sinespeed, self.rand_sinemagnitude = MathUtils.random(1.5, 5.5), MathUtils.random(17, 23)
    self.rand_sinedirection = TableUtils.pick({ -1, 1 })
    if Game.battle.encounter.difficulty >= 2 then
        self.tunnel_size = 85
    else
        self.tunnel_size = 71
    end
    self.retarget = false

    Game.battle:getEnemyBattler("soyingjawsh").manual_move = true

    Game.battle:getEnemyBattler("soyingjawsh"):setAnimation("point")

    Game.battle:getEnemyBattler("soyingjawsh"):slideTo(Game.battle:getEnemyBattler("soyingjawsh").xstart,
                                                       Game.battle:getEnemyBattler("soyingjawsh").ystart, 0.25, "outQuad")
    local rotation_target = 0
    if Game.battle.encounter.difficulty >= 2 then
        rotation_target = math.pi/2
    end
    self.timer:tween(0.35, Game.battle:getEnemyBattler("soyingjawsh").arm, { rotation = rotation_target }, "out-quad", function()
        self.timer:after(0.2, function()
            Game.battle:getEnemyBattler("soyingjawsh").fadeback = true
            Game.battle:getEnemyBattler("soyingjawsh"):slideTo(Game.battle:getEnemyBattler("soyingjawsh").xstart + 60,
                                                               Game.battle:getEnemyBattler("soyingjawsh").ystart, 0.4,
                                                               "linear")
                      
                Assets.playSound("bubble", 1, 3)
            self.timer:after(0.05, function()
                Assets.playSound("bubble", 1, 3.1)
            end)
            self.timer:after(0.1, function()
                Assets.playSound("bubble", 1, 3.2)
            end)
            self.timer:after(0.15, function()
                Assets.playSound("bubble", 1, 3.3)
            end)
                        self.timer:after(0.2, function()
                Assets.playSound("bubble", 1, 3.4)
            end)
            Game.battle:getEnemyBattler("soyingjawsh"):fadeTo(0, 1)
            Game.battle:getEnemyBattler("soyingjawsh").arm:fadeTo(0, 1)
        end)
    end)
end

function tunnel_cardinal:getRemainingTime()
    return self.time - Game.battle.wave_timer
end

function tunnel_cardinal:update()
    if self:getRemainingTime() >= 1.5 and Game.battle.wave_timer > 1 then
        self.timer_rate = self.timer_rate + DT
        self.siner = self.siner + DT

        if self.timer_rate > self.cooldown then
            self.timer_rate = self.timer_rate - self.cooldown

            local y = Game.battle.arena.y + self.rand_sinedirection * (30 * math.cos(self.siner * 2.5) -
                self.rand_sinemagnitude * math.cos(self.siner * 2.5 / self.rand_sinespeed))
            local push = -2
            self:spawnBullet("sword_tunnel", self.spawn_x1, y + self.tunnel_size, math.pi, push,
                             -math.pi / 2)
            self:spawnBullet("sword_tunnel", self.spawn_x1, y - self.tunnel_size, math.pi, push,
                             math.pi / 2)
            if Game.battle.encounter.difficulty >= 2 then
                local x = Game.battle.arena.x + self.rand_sinedirection * (-30 + 40 * math.sin(self.siner * 2.5) -
                    self.rand_sinemagnitude * math.sin(self.siner * 2.5 / self.rand_sinespeed))
                self:spawnBullet("sword_tunnel", x + self.tunnel_size, self.spawn_y2, math.pi / 2, push,
                                 math.pi)
                self:spawnBullet("sword_tunnel", x - self.tunnel_size, self.spawn_y2, math.pi / 2, push,
                                 0)
            end
        end
    elseif self:getRemainingTime() < 4.5 and not self.retarget then
        self.timer:after(1.1, function()
            Assets.playSound("sword_chargeout", 2)
            Assets.playSound("knight_cut1", 1)
        end)
        local sword_remove = math.random(0,2)
        for index, swords in ipairs(self.bullets) do
            if Game.battle.encounter.difficulty >= 2 and index % 3 == sword_remove then
                    swords:remove()
            end
            swords.retarget = true
        end
        Game.battle:getEnemyBattler("soyingjawsh"):setAnimation("point_reverse")
        self.timer:after(0.7, function()
                Game.battle:getEnemyBattler("soyingjawsh").fadeback = false
            Game.battle:getEnemyBattler("soyingjawsh").arm.rotation = -math.pi / 4
            Game.battle:getEnemyBattler("soyingjawsh"):setPosition(Game.battle:getEnemyBattler("soyingjawsh").xstart,
                                                                   Game.battle:getEnemyBattler("soyingjawsh").ystart)
            Game.battle:getEnemyBattler("soyingjawsh").alpha = 1
            Game.battle:getEnemyBattler("soyingjawsh").arm.alpha = 1
            Game.battle:getEnemyBattler("soyingjawsh"):resetSprite()
        end)
        self.retarget = true
    end
    super.update(self)
end

function tunnel_cardinal:onEnd()
    Game.battle:getEnemyBattler("soyingjawsh").siner = 0
    Game.battle:getEnemyBattler("soyingjawsh").manual_move = false
end

return tunnel_cardinal
