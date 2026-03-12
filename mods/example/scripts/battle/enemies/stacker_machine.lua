local StackerMachine, super = Class(EnemyBattler)

function StackerMachine:init()
    super.init(self)
    self.name = "Stacker"
    self:setActor("stacker_machine")

    self.max_health = 1
    self.health = 1
    self.attack = 1
    self.defense = 0
    self.money = 1

    self.check = "A stacker machine.\n* Make it to the top to make money!"

    self.text = {
        "* You stack.",
        "* It all keeps tumbling down.",
        "* The stacker machine shifts back\nand forth.",
        "* Sounds like wasted time.",
        "* The Animal Crossing Nintendo\nSwitch looks tantalizing.",
    }

    self.waves = {
        "stacker",
    }

    self.dialogue = {
        "stacker",
        "Can you make it to the top?"
    }
end

function StackerMachine:getEncounterText()
    if self.money == 1 then
        return super.getEncounterText(self)
    end
    return "* You won!\nAttack to claim your prize!"
end

function StackerMachine:selectWave()
    if self.money == 1 then
        return super.selectWave(self)
    end
    -- Use random wave selection when the script runs out (assuming self.waves is set)
    return "nothing"
end

--[[function StackerMachine:update()
    self.siner = self.siner + DTMULT
    self.time_afterimage = self.time_afterimage + DTMULT
    local parent = self.parent

    --if self.siner < 50 then
    --self.y = self.ystart + 30*math.sin(math.rad(7*self.siner)) + 120
    self.x = self.x +0.15
    if self.time_afterimage > 7 then
        local after_image = AfterImage(self, 0.4, 0.01)
        after_image:addFX(ColorMaskFX())
      --  self.after_image:addFX(AlphaFX(0.9), "battle_end")
        parent:addChild(after_image)
    --    self.time_afterimage = 0
       -- self.after_image:remove()
    end
    --end
end]]

return StackerMachine
