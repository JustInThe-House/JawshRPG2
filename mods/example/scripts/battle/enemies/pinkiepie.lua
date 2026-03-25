local Skeleton, super = Class(EnemyBattler)

function Skeleton:init()
    super.init(self)
    self.name = "Pinkie Pie"
    self:setActor("pinkiepie")

    self.max_health = 200
    self.health = 200
    self.attack = 8
    self.defense = 2
    self.money = 100

    self.check = ""
    self.text = {
        "* Vinny glomps Pinkie a\nlittle too hard.",
        "[facec:jawsh/mad, -30, -13][voice:jawsh]* Why the hell are you here?\n[wait:5]* This is [speed:0.25]MY[speed:1][wait:1] mind dungeon!",
    }

    self.waves = {
        "skeleton/single_shot",
        "skeleton/multi_shot"
    }

    self.dialogue = {
        "No clopping,[wait:3] Vinny!"
    }
end

function Skeleton:update()
    self.check = "HP " ..
        self.health ..
        " ATK " .. self.attack .. " DEF " .. self.defense .. "\n* Its rigid bones make it perfect\nfor a pet wolf."
    super.update(self)
end

return Skeleton
