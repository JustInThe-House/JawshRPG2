local Skeleton, super = Class(EnemyBattler)

function Skeleton:init()
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
        "* The Skeleton's bones rattle\nviolently.",
        "* The Skeleton plays a little\njingle on its ribcage.",
    }

    self.waves = {
        "skeleton/single_shot",
        "skeleton/multi_shot"
    }

    self.dialogue = {}
end

function Skeleton:update()
    self.check = "HP " ..
        self.health ..
        " ATK " .. self.attack .. " DEF " .. self.defense .. "\n* Its rigid bones make it perfect\nfor a pet wolf."
    super.update(self)
end

return Skeleton
