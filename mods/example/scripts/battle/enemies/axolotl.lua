local Axolotl, super = Class(EnemyBattler)

function Axolotl:init()
    super.init(self)
    self.name = "Axolotl"
    self:setActor("axolotl")

    self.max_health = 90
    self.health = 90
    self.attack = 7
    self.defense = 0
    self.money = 60

    self.graze_tension = 2.0

    self.check = ""
    self.text = {
        "* The Axolotl does a cute\ngurgle.",
        "* Who keeps spawning these?",
    }

    self.waves = {
        "axolotl/bubbles",
        "axolotl/spawn",
    }

    self.dialogue = {}
    self.initial_spawn = false
end

function Axolotl:update()
    self.check = "HP " ..
        self.health ..
        " ATK " ..
        self.attack .. " DEF " .. self.defense .. "\n* A cuddly little amphibian.[wait:5]\nMore may spawn if alone."
    super.update(self)
end

function Axolotl:selectWave()
    if #Game.battle.enemies == 1 and not self.initial_spawn then
        self.initial_spawn = true
        self.selected_wave = "axolotl/spawn"
    else
        self.selected_wave = "axolotl/bubbles"
    end
    return self.selected_wave
end

return Axolotl

--commissioned pixelated thing with CB pixelated outro
