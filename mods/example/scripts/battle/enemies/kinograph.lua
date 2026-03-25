local Kinograph, super = Class(EnemyBattler)

function Kinograph:init()
    super.init(self)
    self.name = "Kinograph"
    self:setActor("kinograph")

    self.max_health = 200
    self.health = 200
    self.attack = 8
    self.defense = 2
    self.money = 100

    self.check = ""
    self.text = {
        "* Kinograph views your investments.[wait:7]\n* It's only silver.",
        "* Kinograph says to buy his KinoCoin.[wait:7]\n* It's more than just a cryptocurrency.",
        "* Kinograph checks the market.[wait:7]\n* The S&PLive500 is booming."
    }

    self.waves = {
        "kinograph/snake",
        "kinograph/line_chase"
    }

    self.dialogue = {
        "I only go up!",
        "To the mooooon!",
    }
end

function Kinograph:update()
    self.check = "HP " ..
        self.health ..
        " ATK " ..
        self.attack ..
        " DEF " .. self.defense .. "\n* The greatest investment of all.\n* Hurting him hurts his stock price."
    super.update(self)
end

function Kinograph:onHurt(damage, battler)
    super.onHurt(self, damage, battler)
    Game.battle.timer:tween(0.5, self:getActiveSprite(), { sum = math.min(self:getActiveSprite().sum + 15,16.9) })
end

return Kinograph
