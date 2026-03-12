local ActingManiac, super = Class(Encounter)

function ActingManiac:init()
    super.init(self)

    self.text = "* Acting Maniac strikes again!"

    self:addEnemy("acting_maniac")

    self.background = true
    self.music = "battle"
end

return ActingManiac
