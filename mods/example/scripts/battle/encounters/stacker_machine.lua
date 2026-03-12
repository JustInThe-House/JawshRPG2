local Stacker, super = Class(Encounter)

function Stacker:init()
    super.init(self)

    self.text = "* Stacker."

    self:addEnemy("stacker_machine", 500, 200)

    self.background = true
    self.music = "arcade_battle"
end

return Stacker