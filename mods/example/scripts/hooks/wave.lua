---@class Wave : Object

local Wave, super = HookSystem.hookScript(Wave)

function Wave:update()
    super.update(self)
    for _, battler in ipairs(Game.battle.party) do
        if battler.heal_over_time > 0 and not battler.is_down and battler.chara:getHealth() < battler.chara:getStat("health") then
            battler.heal_over_timer = battler.heal_over_timer + DT
            if battler.heal_over_timer > 0.5 then
                battler.chara:setHealth(battler.chara:getHealth() + 1)
                battler.heal_over_time = battler.heal_over_time - 1
                battler.heal_over_timer = 0
            end

            --could actually do an overheal
        end
    end
end

return Wave
