local DrFauci, super = Class(EnemyBattler)

function DrFauci:init()
    super.init(self)
    self.name = "Skeleton"
    self:setActor("skeleton")

    self.max_health = 200
    self.health = 200
    self.attack = 8
    self.defense = 2
    self.money = 100

    self.check = ""
    self.text = {
        "* Fauci twists open his index finger to reveal a COVID shot.",
        "* Dr. Fauci sings about loving science.",
        "* Dr. Fauci faxes you some Sciencemas cheer.",
        "* The Doc plans to give you a Fauci Ouchie.",
    }

    self.waves = {
        "skeleton/single_shot",
        "skeleton/multi_shot"
    }

    self.dialogue = {}
end

function DrFauci:update()
    self.check = "HP "..self.health.." ATK " .. self.attack .. " DEF " .. self.defense .. "\n* A lone doctor saving the world,[wait:5]\none vaccine at a time."
    super.update(self)

end

return DrFauci
