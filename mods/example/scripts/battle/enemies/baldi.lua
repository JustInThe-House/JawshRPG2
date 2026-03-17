local Baldi, super = Class(EnemyBattler)

function Baldi:init()
    super.init(self)
    self.name = "Baldi"
    self:setActor("baldi")

    self.max_health = 200
    self.health = 200
    self.attack = 8
    self.defense = 2
    self.money = 100

    self.check = ""
    self.text = {
        "* Baldi looks disapprovingly at\nVinny and Jawsh.",
        "* Baldi's ruler slapping frequency\nincreases.",
        "* Looks like you'll both be failing math again.",
    }

    self.waves = {
        "baldi/ruler",
        "baldi/question"
    }

    self.dialogue = {
        "Time for everyone's favorite subject!",
        "[speed:0.7]Problem 1:[wait:10]You!"
    }
end

function Baldi:update()
    self.check = "HP "..self.health.." ATK " .. self.attack .. " DEF " .. self.defense .. "\n* A low-poly math teacher.\nDon't get his questions wrong!"
    super.update(self)

end

return Baldi
