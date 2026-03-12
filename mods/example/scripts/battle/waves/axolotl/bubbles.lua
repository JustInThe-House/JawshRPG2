local Bubbles, super = Class(Wave)

function Bubbles:init()
    super.init(self)
    self.time = 6
end

function Bubbles:onStart()
            -- Get all enemies that selected this wave as their attack
    local attackers = self:getAttackers()
for _, attacker in ipairs(attackers) do
local x, y = attacker:getRelativePos(attacker.width / 2, attacker.height / 2)

    self.timer:every(0.5 + MathUtils.random(0.25,0.4) * (#Game.battle.enemies-1), function()
            local rand = TableUtils.pick({-1,1})
            self:spawnBullet("bubble", x, y, math.pi+rand*math.pi/4+MathUtils.random(-math.pi/16,math.pi/16), 9,rand*math.pi/2)
            Assets.playSound("minecraft/bubble", 1, MathUtils.random(0.9,1.1))
        end)
    end
end

return Bubbles
