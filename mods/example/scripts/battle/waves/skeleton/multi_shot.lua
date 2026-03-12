local MultiShot, super = Class(Wave)

function MultiShot:init()
    super.init(self)
    self.time = 6
end

function MultiShot:onStart()
    self.attackers = self:getAttackers()
    for _, attacker in ipairs(self.attackers) do
        attacker:setSprite("aiming")
    end
    Assets.playSound("minecraft/bow_load")
    self.timer:every(0.5 + MathUtils.random(0.1,0.25) * (#Game.battle.enemies-1), function()
        -- Get all enemies that selected this wave as their attack
        local center_x,center_y = Game.battle.arena:getCenter()
        for _, attacker in ipairs(self.attackers) do
            local x, y = attacker:getRelativePos(attacker.width / 2, attacker.height / 2)
            local arena_angle = MathUtils.angle(attacker.x, attacker.y, center_x,center_y)
            local rand_angle = MathUtils.random(-math.pi / 8, math.pi / 8)

            self:spawnBullet("arrow", x, y, arena_angle + math.rad(10) + rand_angle, 12)
            self:spawnBullet("arrow", x, y, arena_angle - math.rad(10) + rand_angle, 12)
            self:spawnBullet("arrow", x, y, arena_angle + math.rad(20) + rand_angle, 12)
            self:spawnBullet("arrow", x, y, arena_angle - math.rad(20) + rand_angle, 12)
            Assets.playSound("minecraft/bow_shoot")
        end
    end)
end

function MultiShot:onEnd()
    local attackers = self:getAttackers()
    for _, attacker in ipairs(self.attackers) do
        attacker:resetSprite()
    end
end

return MultiShot
