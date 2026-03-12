local Axolotl, super = Class(Encounter)

function Axolotl:init()
    super.init(self)

    self.text = "* Axolotls spawn in!"

    self:addEnemy("axolotl")
    self:addEnemy("axolotl")
    self:addEnemy("axolotl")

    self.background = true
    self.music = "battle"
end

return Axolotl
