local GVBlueberries, super = Class(EnemyBattler)

function GVBlueberries:init()
    super.init(self)
    self.name = "Great Value Blueberries"
    self:setActor("gv_blueberries")

    self.max_health = 200
    self.health = 200
    self.attack = 8
    self.defense = 2
    self.money = 100

    self.check = ""
    self.text = {
        "* Life or death for this berry boy?",
        "* It's a wonderful day for pie!",
    }

    self.waves = {
        "gvblueberries/chicken_heal",
        "gvblueberries/multi_shot"
    }

    self.dialogue = {
        "weeeehhhh immmaa ppuuppppyyyyyy :333",
        "Come on, take a bite!"
    }
end

function GVBlueberries:update()
    self.check = "HP "..self.health.." ATK " .. self.attack .. " DEF " .. self.defense .. "\n* You can't escape 'em!\n* Get ready for a berry blast!"
    super.update(self)

end

return GVBlueberries
