local Igi, super = Class(Encounter)

function Igi:init()
    super.init(self)

    self.text = "* The -igis squeegie in!"

    self:addEnemy("igi")

    self.background = true
    self.music = "battle"
end

return Igi
