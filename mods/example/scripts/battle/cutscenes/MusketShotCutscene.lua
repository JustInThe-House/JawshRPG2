return function(cutscene, battler)
    -- may add extra damage for headshot. would just be an extra hitbox that deals more damage.
    cutscene:wait(0.25)

    local shooter = MusketShot()
    local deal_damage = false --added so attack can't double hit stacked sprites
    Game.battle:addChild(shooter)
    shooter:setup()
    Assets.playSound("gun_cock")
    cutscene:text("* " .. battler.chara:getName() .. " took aim!\nPress [bind:confirm] to fire!",
                  { wait = false, advance = false })

    cutscene:wait(function()
        if Input.pressed("confirm") then
            Input.clear("confirm")
            return true
        end
    end)
    Assets.playSound("gunshot")
    cutscene:text("", { wait = false })

    local hit = cutscene:wait(shooter:shoot())


    for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
        if TableUtils.contains(hit, enemy) and not deal_damage then
            deal_damage = true
            local attack = 0
            if battler.chara:checkArmor("revengestick") then
                for _, battler in ipairs(Game.battle.party) do
                    if battler.is_down then
                        battler.chara:addStatBuff("revenge", 1)
                    end
                end
            end
            if battler.chara:getStat("revenge") > 1 then
                attack = attack + 7
            end
            -- tp amount
            attack = attack +
                MathUtils.round(select(2, battler.chara:checkArmor("delusionbrace")) * Game:getTension() / 12.5)
            -- stache
            attack = attack + select(2, battler.chara:checkArmor("stache")) * math.random(-4, 6)

            -- attack and magic
            attack = attack + MathUtils.round(battler.chara:getStat("attack")) + battler.chara:getStat("magic") / 2
            enemy:hurt(MathUtils.round(math.max(attack - enemy.defense, 0) * 7.5 * MathUtils.random(0.95, 1.05)), battler)
        else
        end
    end

    if #hit == 0 then
        cutscene:text("* Missed!")
    else
        cutscene:text("* Bullseye!")
    end
    shooter:remove() -- maybe do this before the text? like in the if? double stated, but it works
    cutscene:wait(0.1)

    -- note: for some reason holding on the after attack area causes the game to crash. no idea why. i dont think its the entire attack, just at the end
end
