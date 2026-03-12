---@class EnemyBattler : Battler
---
---@field reset_sprite        string             Enemies can't have both an idle and walk anim, so this must be specified.

local HappyGuy, super = Class(EnemyBattler)

function HappyGuy:init() -- on addenemy, any extra arguments put in the parentheses
    super.init(self)
    self.name = "America-Pilled ChudJack"
    self:setActor("americapilledchudjack")
    self.reset_sprite = "idle"
    self:setAnimation(self.reset_sprite)
    self.width = 124 * 0.3 -- idle sprite size
    self.height = 131 * 0.3 -- idle sprite size
    self.max_health = 1000
    self.health = 1000
    self.attack = 10
    self.defense = 4
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
        "happyguy/pickaxe_updown",
        -- 1 more normal, 1 special attack
    }

    self.dialogue = {
        "This is what the\nAmerican Dream is\nall about!",
        {"The best thing about\nbaseball...", "...is you can bring\nPISTOLS to the GAME!!!"} -- would need to make this a cutscene to add the animations
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
    --self.width = 80 * 0.3
    --self.height = 160 * 0.3
end

return HappyGuy
