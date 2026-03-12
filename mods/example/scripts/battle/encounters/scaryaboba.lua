local Aboba, super = Class(Encounter)

function Aboba:init()
    super.init(self)

    self.text = "* ABOBA."

    self:addEnemy("scaryaboba", 500, 220)

    self.background = true
    self.music = "battle"
end

return Aboba
