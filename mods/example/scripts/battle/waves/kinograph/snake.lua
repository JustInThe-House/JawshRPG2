local Snake, super = Class(Wave)

function Snake:init()
    super.init(self)
    self.time = 6
end

function Snake:onStart()
    local r = 120
    local angle = MathUtils.random(0, 2 * math.pi)
    local arena = Game.battle.arena
    self.attackers = self:getAttackers()
    for _, attacker in ipairs(self.attackers) do
        self.timer:after(0.25, function()
            self:spawnBullet("kinograph/snake", arena.x + r * math.cos(angle), arena.y + r * math.sin(angle))
        end)
    end
end

return Snake
