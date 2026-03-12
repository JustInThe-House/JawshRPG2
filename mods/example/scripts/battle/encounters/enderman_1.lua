local Skeleton, super = Class(Encounter)

function Skeleton:init()
    super.init(self)

    self.text = "* Blind Enderman teleports in!"

    self:addEnemy("enderman")

    self.background = true
    self.music = "battle"
end

return Skeleton
