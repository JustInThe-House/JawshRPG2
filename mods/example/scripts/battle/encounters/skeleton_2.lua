local Skeleton, super = Class(Encounter)

function Skeleton:init()
    super.init(self)

    self.text = "* Skeleton spawns in!"


    self:addEnemy("skeleton")
    self:addEnemy("axolotl")


    self.background = true
    self.music = "silly_battle"
end

return Skeleton
