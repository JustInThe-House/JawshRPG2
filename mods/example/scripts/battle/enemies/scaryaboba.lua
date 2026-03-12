local Aboba, super = Class(EnemyBattler)

function Aboba:init()
    super.init(self)
    self.name = "Scary ABOBA"
    self:setActor("scaryaboba")

    self.max_health = 200
    self.health = 200
    self.attack = 8
    self.defense = 2
    self.money = 100

    self.check = ""
    self.text = {
        "* Baldi looks disapprovingly at\nVinny and Jawsh.",
        "* Baldi's ruler slapping frequency\nincreases.",
        "* Looks like you'll both be failing math again!",
    }

    self.waves = {
        "skeleton/single_shot",
        "skeleton/multi_shot"
    }

    self.dialogue = {}
end

function Aboba:update()
    self.check = "HP "..self.health.." ATK " .. self.attack .. " DEF " .. self.defense .. "\n* A low-poly math teacher.\nDon't get his questions wrong!"
    super.update(self)

end

return Aboba
