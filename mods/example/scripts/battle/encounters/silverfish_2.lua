local Axolotl, super = Class(Encounter)

function Axolotl:init()
    super.init(self)

    self.text = "* Silverfish shake in!"

    self:addEnemy("silverfish")
    self:addEnemy("silverfish")

    self.background = true
    self.music = "battle"
end

return Axolotl
