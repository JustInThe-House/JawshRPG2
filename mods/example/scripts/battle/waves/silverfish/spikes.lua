local Spikes, super = Class(Wave)

function Spikes:init()
    super.init(self)
    self.time = 6
    self.siner = 0
end

function Spikes:onStart()
    -- Get all enemies that selected this wave as their attack
    self.attackers = self:getAttackers()
    for _, attacker in ipairs(self.attackers) do
        attacker.spikes_start_x = attacker.x
        attacker.spikes_start_y = attacker.y
        local x_start = MathUtils.random((SCREEN_WIDTH / 2) - 72, (SCREEN_WIDTH / 2) + 72)
        self.timer:tween(0.5, attacker, { x = x_start, y = 300 }, "linear", function()
            attacker.siner = MathUtils.random(0, 2 * math.pi)
            attacker.sining = true
        end)
    end

    -- Loop through all attackers
    for _, attacker in ipairs(self.attackers) do
        -- Get the attacker's center position

        self.timer:every(MathUtils.random(0.2, 0.3) + 0.2 * #self.attackers, function()
            local x, y = attacker:getRelativePos(attacker.width / 2, attacker.height / 3)
            for i = -1, 1 do
                self:spawnBullet("smallbullet", x, y, -math.pi / 2 + i * math.pi / 4, 7)
            end
            self.timer:tween(0.1, attacker, {scale_y = 2.5}, "linear", function()
                self.timer:tween(0.2, attacker, {scale_y = 2})
            end)
            Assets.playSound("minecraft/bow_shoot", 1, 1.5)
        end)
    end
end

function Spikes:onEnd()
    for _, attacker in ipairs(self.attackers) do
        Game.battle.timer:tween(0.4, attacker, { x = attacker.spikes_start_x, y = attacker.spikes_start_y , scale_y = 2})
        attacker.sining = false
        attacker.spikes_start_x = nil
        attacker.spikes_start_y = nil
    end
end

return Spikes
