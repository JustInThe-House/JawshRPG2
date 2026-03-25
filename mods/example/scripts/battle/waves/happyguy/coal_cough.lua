local Cough, super = Class(Wave)

function Cough:init()
    super.init(self)
    self.time = 8
    self.shaking = false
    self.happyguy = Game.battle:getEnemyBattler("happyguy")
    Game.battle.timer:tween(0.4, self.happyguy, { x = SCREEN_WIDTH + 40 })
end

function Cough:onStart()
    self.attackers = self:getAttackers()
    local soul = Game.battle.soul
    local arena = Game.battle.arena
    self.happyguy.layer = BATTLE_LAYERS["above_bullets"]
    self.happyguy:setPosition(SCREEN_WIDTH / 2 + 10, SCREEN_HEIGHT + 60)
    self.happyguy:setAnimation("cough")
    self.timer:tween(0.5, self.happyguy, { y = self.happyguy.y - 120 })
    self.timer:every(1.2, function()
        Assets.playSound("cough", 1, MathUtils.random(0.8, 1.2))
        local shake = 1 + Game.battle.encounter.difficulty
        Game.battle.arena:shake(TableUtils.pick({ -shake, shake }), TableUtils.pick({ -shake, shake }), 0, 2 / 30)
        self.timer:after(0.4 + 0.1 * Game.battle.encounter.difficulty, function()
            Game.battle.arena:stopShake()
        end)
        local xoffset = -8
        for _, attacker in ipairs(self.attackers) do
            local x, y = attacker:getRelativePos((attacker.width / 2),
                                                 (attacker.height / 2))
            local angle = MathUtils.angle(x, y, soul.x, soul.y)
            for i = 1, 5 + Game.battle.encounter.difficulty do
                self:spawnBullet("smoke_cough", x + xoffset, y,
                                 angle + MathUtils.random(-math.pi / 5, math.pi / 5),
                                 MathUtils.random(1, 5))
            end
        end
    end)
    if Game.battle.encounter.difficulty >= 1 then
        for i = 1, 8 do
            self:spawnBullet("smoke_fog", arena.x + MathUtils.random(-48, 48), arena.y + MathUtils.random(-64, 128))
        end
        if Game.battle.encounter.difficulty >= 2 then
            for i = 1, 4 do
                self:spawnBullet("smoke_fog", arena.x + MathUtils.random(-48, 48), arena.y + MathUtils.random(-64, 128))
            end
        end
    end
end

function Cough:update()
    super.update(self)
end

function Cough:onEnd()
    self.happyguy:setAnimation(self.happyguy.reset_sprite)
    self.happyguy:slideTo(self.happyguy.target_x,
                          self.happyguy.target_y, 0.5, "linear") --after function not working for some reason
end

return Cough
