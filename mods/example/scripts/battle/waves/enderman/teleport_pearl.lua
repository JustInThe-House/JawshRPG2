local TeleportPearl, super = Class(Wave)

function TeleportPearl:init()
    super.init(self)
    self.time = 6
end

function TeleportPearl:onStart()
    self.attackers = self:getAttackers()
    for _, attacker in ipairs(self.attackers) do
        self.timer:after(0.25, function()
            local x, y = attacker:getRelativePos(attacker.width / 2, attacker.height / 2)
            local angle = MathUtils.angle(x,y,Game.battle.soul.x,Game.battle.soul.y )
            self:spawnBullet("ender_pearl", x, y, angle, 10)
            Assets.playSound("minecraft/endereye_launch", 1.5, MathUtils.random(0.9, 1.1))
        end)
    end
end

return TeleportPearl
