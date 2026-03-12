local Deku, super = Class(EnemyBattler)

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
        "Come on,[wait:5] the bitrate isn't\nTHAT bad.",
        "A video of Bloons appears on\nthe Bitrate Bomb.",
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
