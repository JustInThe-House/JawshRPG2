local Enderman, super = Class(EnemyBattler)

function Enderman:init()
    super.init(self)
    self.name = "Enderman"
    self:setActor("enderman")

    self.max_health = 350
    self.health = 350
    self.attack = 8
    self.defense = 1
    self.money = 160

    self.check = ""
    self.text = {
        "* The Blind Enderman croaks at a consistent beat.",
        "* The Blind Enderman stares at...\nsomething. [wait:5]Probably.",
    }

    self.waves = {
        "enderman/teleport_pearl",
        "enderman/particles"
    }

    self.dialogue = {}
end


function Enderman:update()
    self.check = "HP " ..
    self.health ..
    " ATK " .. self.attack .. " DEF " .. self.defense .. "\n* Its eyes suck souls from bodies.[wait:5]\nLuckily, [wait:5]you can't see them."
    super.update(self)
end


return Enderman
