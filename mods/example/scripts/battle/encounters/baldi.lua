local Baldi, super = Class(Encounter)

function Baldi:init()
    super.init(self)

    self.text = "* Baldi slaps in!"

    self:addEnemy("baldi")

    self.background = true
    self.music = "battle"
end

return Baldi
