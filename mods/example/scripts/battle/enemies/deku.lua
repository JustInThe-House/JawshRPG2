local Deku, super = Class(EnemyBattler)

function Deku:init()
    super.init(self)
    self.name = "Deku"
    self:setActor("deku")

    self.max_health = 200
    self.health = 200
    self.attack = 8
    self.defense = 2
    self.money = 100

    self.check = ""
    self.text = {
        "* Deku is bussin.",
        "* Smells like fried chicken.",
    }

    self.waves = {
        "deku/chicken_heal",
        "deku/multi_shot"
    }

    self.dialogue = {
        "weeeehhhh immmaa ppuuppppyyyyyy :333",
        "Come on, take a bite!"
    }
end

function Deku:update()
    self.check = "HP "..self.health.." ATK " .. self.attack .. " DEF " .. self.defense .. "\n* A Popeyes-loving superhero.\nWatch out for Puppy in the background."
    super.update(self)

end

return Deku
