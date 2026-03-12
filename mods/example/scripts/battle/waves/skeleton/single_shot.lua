local SingleShot, super = Class(Wave)

function SingleShot:init()
    super.init(self)
    self.time = 6
end

function SingleShot:onStart()
            -- Get all enemies that selected this wave as their attack
            self.attackers = self:getAttackers()
    for _, attacker in ipairs(self.attackers) do
        attacker:setSprite("aiming")
    end
    Assets.playSound("minecraft/bow_load")

    self.timer:every(0.5 + MathUtils.random(0.1,0.25) * (#Game.battle.enemies-1), function()

        -- Loop through all attackers
        for _, attacker in ipairs(self.attackers) do
            -- Get the attacker's center position
            local x, y = attacker:getRelativePos(attacker.width / 2, attacker.height / 2)

            local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)

            self:spawnBullet("arrow", x, y, angle+math.pi/30+MathUtils.random(-math.pi/24,math.pi/24), 15)
            Assets.playSound("minecraft/bow_shoot")
        end
    end)
end

function SingleShot:onEnd()
    for _, attacker in ipairs(self.attackers) do
        attacker:resetSprite()
    end
end

return SingleShot
