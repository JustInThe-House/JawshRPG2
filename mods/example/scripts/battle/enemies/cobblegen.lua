local Cobblegen, super = Class(EnemyBattler)

function Cobblegen:init()
    super.init(self)
    self.name = "Cobblegen"
    self:setActor("nothing")

    self.max_health = 1
    self.health = 1
    self.attack = 1
    self.defense = 0
    self.money = 0

    self.check = "A cobblegen.\n"

    self.text = {}

    self.waves = {
        "cobblegen",
    }

    self.dialogue = {
        "Build a cobblestone generator!"
    }
end

return Cobblegen
