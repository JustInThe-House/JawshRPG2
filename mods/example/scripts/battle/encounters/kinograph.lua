local Kinograph, super = Class(Encounter)

function Kinograph:init()
    super.init(self)

    self.text = "* Kinograph soars high!"

    self:addEnemy("kinograph")

    self.background = true
    self.music = "battle"
end

return Kinograph
