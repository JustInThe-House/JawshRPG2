local Cobblegen, super = Class(Encounter)

function Cobblegen:init()
    super.init(self)

    self.text = "* Cobblegen."

    self:addEnemy("cobblegen", 500, 200)

    self.background = true
    self.music = "puzzle_battle"
end

function Cobblegen:onStateChange(old)
    if old == "INTRO" then
        Game.battle:setState("DEFENDINGBEGIN")
    end
end

return Cobblegen