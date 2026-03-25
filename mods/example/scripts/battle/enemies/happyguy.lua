---@class EnemyBattler : Battler
---
---@field reset_sprite        string             Enemies can't have both an idle and walk anim, so this must be specified.

local HappyGuy, super = Class(EnemyBattler)

function HappyGuy:init() -- on addenemy, any extra arguments put in the parentheses
    super.init(self)
    self.name = "Happy Guy"
    self:setActor("happyguy")
    self.reset_sprite = "idle"
    self:setAnimation(self.reset_sprite)
    self.width = 124 * 0.3 -- idle sprite size
    self.height = 131 * 0.3 -- idle sprite size
    self.max_health = 1000
    self.health = 1000
    self.attack = 9
    self.defense = 0
    self.money = 400

    self.check = ""
    self.text = {
        "* Happy Guy's ice cream melts from\nhis mouth.",
        "* Smells like fossil fuel.",
        "* A strong breeze blows from the top of the castle."
    }

    self.waves = {
        "happyguy/mine",
        "happyguy/mine_cone",
        "happyguy/pickaxe_spin",
        "happyguy/pickaxe_tunnel",
        "happyguy/coal_cough",
        -- 1 special attack
    }

    self.dialogue = {
        "So why...[wait:7] why\nwould you want to\ndestroy this place?"
    }
end

function HappyGuy:update()
    self.check = "HP " ..
    self.health ..
    " ATK " ..
    self.attack .. " DEF " .. self.defense .. "\n* A Popeyes-loving superhero.\nWatch out for Puppy in the background."
    super.update(self)
end

function HappyGuy:onDefeat(damage, battler)
    super.onDefeat(self, damage, battler)
    self.width = 80 * 0.3
    self.height = 160 * 0.3
end

return HappyGuy
