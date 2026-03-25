local PinkiePie, super = Class(Encounter)

function PinkiePie:init()
    super.init(self)

    self.text = "* Pinkie Pie trots in!"

    self:addEnemy("pinkiepie")

    self.background = true
    self.music = "battle"
end

return PinkiePie
