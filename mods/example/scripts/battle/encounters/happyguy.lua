local HappyGuy, super = Class(Encounter)

function HappyGuy:init()
    super.init(self)

    self.text = "* Happy Guy blocks the way!"

    self:addEnemy("happyguy", 520, 200)
    

    self.background = true
    self.battleroom_upper = "minecraft"
    self.battleroom_lower = nil
    self.battleroom_bg = nil
    self.music = "battle"
end

return HappyGuy
