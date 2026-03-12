local Skeleton, super = Class(Encounter)

function Skeleton:init()
    super.init(self)

    self.text = "* Skeleton spawns in!"

    self:addEnemy("skeleton")
    

    self.background = true
    self.music = "battle"
end

return Skeleton
