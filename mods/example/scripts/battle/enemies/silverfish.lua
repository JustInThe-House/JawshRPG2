local Silverfish, super = Class(EnemyBattler)

function Silverfish:init()
    super.init(self)
    self.name = "Silverfish"
    self:setActor("silverfish")

    self.max_health = 80
    self.health = 80
    self.attack = 7
    self.defense = 0
    self.money = 40
    self.shield = 0
    self.sining = false
    self.siner = 0
    
    self.comment = ""
    self.check = ""
    self.text = {
        "* The Silverfish does the\nJoseph shake.",
        "* The Silverfish flares its spines.",
    }

    self.waves = {}

    self.dialogue = {}
   -- self:hide()
end

function Silverfish:update()
    self.check = "HP " ..
        self.health ..
        " ATK " ..
        self.attack .. " DEF " .. self.defense .. "\n* A spiky little arthropod.[wait:5]\nCan hide in blocks to keep safe."
        if self.sining then
            self.siner = self.siner + DT
            self.x = self.x + math.cos(self.siner * (2 - #Game.battle.enemies * 0.3))
        end
    super.update(self)
end

function Silverfish:selectWave()
    if self:getActiveSprite() == "hidden" then
        self.selected_wave = "silverfish/spikes"
    else
        if math.random(1,4) == 1 then
            self.selected_wave = "silverfish/hide"
        else
            self.selected_wave = "silverfish/spikes"
        end
    end
    return self.selected_wave
end

function Silverfish:onHurt(damage,battler)
    super.onHurt(self,damage,battler)
    local shield_start = self.shield
    self.shield = math.max(self.shield - damage,0) 
            if self.shield == 0 and shield_start > 0 then
            self.defense = 0
            self:setSprite("idle")
            self.comment = ""
            local y_start = self.y
            Game.battle.timer:tween(0.2, self, {y = y_start-30}, "out-quad", function()
                Game.battle.timer:tween(0.6, self, {y=y_start}, "in-bounce")
            end)
        end
end

function Silverfish:hide()
            self.defense = 4
            self.shield = 40
            self:setSprite("hidden")
            self.comment = "Hidden"
end

return Silverfish

--commissioned pixelated thing with CB pixelated outro
