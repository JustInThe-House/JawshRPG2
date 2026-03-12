local Deku, super = Class(EnemyBattler)
--how to rotate jerry seinfeld in mspaint
function Deku:init()
    super.init(self)
    self.name = "Bitrate Bomb"
    self:setActor("deku")

    self.max_health = 200
    self.health = 200
    self.attack = 8
    self.defense = 2
    self.money = 100

    self.check = ""
    self.text = {
        "DogPiss is leaking.",
        "DogPiss needs to go to the bathroom, now.",
        "DogPiss stands and stares."
    }

    self.waves = {
        "skeleton/multi_shot"
    }

    self.dialogue = {}
end

function Deku:update()
    self.check = "HP "..self.health.." ATK " .. self.attack .. " DEF " .. self.defense .. "\n* A Popeyes-loving superhero.\nWatch out for Puppy in the background."
    super.update(self)

end

return Deku
