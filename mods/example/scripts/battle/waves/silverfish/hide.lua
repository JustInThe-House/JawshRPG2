local Hide, super = Class(Wave)

function Hide:init()
    super.init(self)
    self.time = 1
end

function Hide:onStart()
    -- Get all enemies that selected this wave as their attack
    self.attackers = self:getAttackers()
    for _, attacker in ipairs(self.attackers) do
        attacker.hiding = true
        attacker:hide()
    end
end

return Hide