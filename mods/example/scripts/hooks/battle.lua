-- includes targeting players. Removed the original retargeting (one which didnt do anything, and the other retargets if Kris), and incorporates cloak effect. removes EXP in text on victory
--removed something about soul alpha that was causing it to turn red. may need fixing if i want to change soul alpha at start
-- added special bgs and floors of battlerooms. image files determined on draw so switching bgs via changing encounter value is easy.
local Battle, super = HookSystem.hookScript(Battle)

function Battle:hurt(amount, exact, target, swoon)
    -- If target is a numberic value, it will hurt the party battler with that index
    -- "ANY" will choose the target randomly
    -- "ALL" will hurt the entire party all at once
    target = target or "ANY"

    -- Alright, first let's try to adjust targets.

    if type(target) == "number" then
        target = self.party[target]
    end

    if isClass(target) and target:includes(PartyBattler) then
        if (not target) or (target.chara:getHealth() <= 0) then -- Why doesn't this look at :canTarget()? Weird.
            target = self:randomTargetOld()
        end
    end

    if target == "ANY" then
        target = self:randomTargetOld()

        -- Calculate the average HP of the party.
        -- This is "scr_party_hpaverage", which gets called multiple times in the original script.
        -- We'll only do it once here, just for the slight optimization. This won't affect accuracy.

        -- Speaking of accuracy, this function doesn't work at all!
        -- It contains a bug which causes it to always return 0, unless all party members are at full health.
        -- This is because of a random floor() call.
        -- I won't bother making the code accurate; all that matters is the output.

        local party_average_hp = 1

        for _, battler in ipairs(self.party) do
            if battler.chara:getHealth() ~= battler.chara:getStat("health") then
                party_average_hp = 0
                break
            end
        end


        -- Retarget if not at full?

        -- Retarget if cloak
        if select(2, target.chara:checkArmor("cloak")) > 0 then
            target = self:randomTargetOld()
        end

        -- Retarget if not bullseye
        if select(2, target.chara:checkArmor("bullseye")) == 0 then
            target = self:randomTargetOld()
        end


        -- retarget if target's taunt value is 0 or nil
        if target.chara:getStat("taunt") == nil or target.chara:getStat("taunt") == 0 then
            target = self:randomTargetOld()
        end
        if target.chara:getStat("taunt") == nil or target.chara:getStat("taunt") == 0 then
            target = self:randomTargetOld()
        end
        if target.chara:getStat("taunt") == nil or target.chara:getStat("taunt") == 0 then
            target = self:randomTargetOld()
        end
        if target.chara:getStat("taunt") == nil or target.chara:getStat("taunt") == 0 then
            target = self:randomTargetOld()
        end

        -- If we landed on Kris (or, well, the first party member), and their health is low, retarget (plot armor lol)
        --  if (target == self.party[1]) and ((target.chara:getHealth() / target.chara:getStat("health")) < 0.35) then
        --     target = self:randomTargetOld()
        --  end

        -- They got hit, so un-darken them
        target.should_darken = false
        target.targeted = true
    end

    -- Now it's time to actually damage them!
    if isClass(target) and target:includes(PartyBattler) then
        target:hurt(amount, exact, nil, { swoon = self.encounter:canSwoon(target) and swoon })
        return { target }
    end

    if target == "ALL" then
        Assets.playSound("hurt")
        local alive_battlers = TableUtils.filter(self.party, function(battler) return not battler.is_down end)
        for _, battler in ipairs(alive_battlers) do
            battler:hurt(amount, exact, nil, { all = true, swoon = self.encounter:canSwoon(battler) and swoon })
        end
        -- Return the battlers who aren't down, aka the ones we hit.
        return alive_battlers
    end
end

function Battle:processAction(action)
    local battler = self.party[action.character_id]
    local party_member = battler.chara
    local enemy = action.target

    self.current_processing_action = action

    local next_enemy = self:retargetEnemy()
    if not next_enemy then
        return true
    end

    if enemy and enemy.done_state then
        enemy = next_enemy
        action.target = next_enemy
    end

    -- Call mod callbacks for onBattleAction to either add new behaviour for an action or override existing behaviour
    -- Note: non-immediate actions require explicit "return false"!
    local callback_result = Kristal.modCall("onBattleAction", action, action.action, battler, enemy)
    if callback_result ~= nil then
        return callback_result
    end
    for lib_id, _ in Kristal.iterLibraries() do
        callback_result = Kristal.libCall(lib_id, "onBattleAction", action, action.action, battler, enemy)
        if callback_result ~= nil then
            return callback_result
        end
    end

    if action.action == "SPARE" then
        local worked = enemy:canSpare()

        local text = enemy:getSpareText(battler, worked)
        if text then
            self:battleText(text)
        end

        battler:setAnimation("battle/spare", function()
            enemy:onMercy(battler)
            if not worked then
                enemy:mercyFlash()
            end
            self:finishAction(action)
        end)

        return false
    elseif action.action == "ATTACK" or action.action == "AUTOATTACK" then
        local attacksound = battler.chara:getWeapon():getAttackSound(battler, enemy, action.points) or
            battler.chara:getAttackSound()
        local attackpitch = battler.chara:getWeapon():getAttackPitch(battler, enemy, action.points) or
            battler.chara:getAttackPitch()
        local src         = Assets.stopAndPlaySound(attacksound or "laz_c")
        src:setPitch(attackpitch or 1)

        self.actions_done_timer = 1.2

        local crit = action.points == 150 and action.action ~= "AUTOATTACK"
        if crit then
            Assets.stopAndPlaySound("criticalswing")

            for i = 1, 3 do
                local sx, sy = battler:getRelativePos(battler.width, 0)
                local sparkle = Sprite("effects/criticalswing/sparkle", sx + MathUtils.random(50),
                                       sy + 30 + MathUtils.random(30))
                sparkle:play(4 / 30, true)
                sparkle:setScale(2)
                sparkle.layer = BATTLE_LAYERS["above_battlers"]
                sparkle.physics.speed_x = MathUtils.random(2, 6)
                sparkle.physics.friction = -0.25
                sparkle:fadeOutSpeedAndRemove()
                self:addChild(sparkle)
            end
        end

        battler:setAnimation("battle/attack", function()
            action.icon = nil

            if action.target and action.target.done_state then
                enemy = self:retargetEnemy()
                action.target = enemy
                if not enemy then
                    self.cancel_attack = true
                    self:finishAction(action)
                    return
                end
            end

            local damage = MathUtils.round(enemy:getAttackDamage(action.damage or 0, battler, action.points or 0))
            if damage < 0 then
                damage = 0
            end

            if damage > 0 then
                Game:giveTension(MathUtils.round(enemy:getAttackTension(action.points or 100, battler)))

                local attacksprite = battler.chara:getWeapon():getAttackSprite(battler, enemy, action.points) or
                    battler.chara:getAttackSprite()
                local dmg_sprite = Sprite(attacksprite or "effects/attack/cut")
                dmg_sprite:setOrigin(0.5, 0.5)
                if crit then
                    dmg_sprite:setScale(2.5, 2.5)
                else
                    dmg_sprite:setScale(2, 2)
                end
                local relative_pos_x, relative_pos_y = enemy:getRelativePos(enemy.width / 2, enemy.height / 2)
                dmg_sprite:setPosition(relative_pos_x + enemy.dmg_sprite_offset[1],
                                       relative_pos_y + enemy.dmg_sprite_offset[2])
                dmg_sprite.layer = enemy.layer + 0.01
                dmg_sprite.battler_id = action.character_id or nil
                table.insert(enemy.dmg_sprites, dmg_sprite)
                local dmg_anim_speed = 1 / 15
                if attacksprite == "effects/attack/shard" then
                    -- Ugly hardcoding BlackShard animation speed accuracy for now
                    dmg_anim_speed = 1 / 10
                end
                dmg_sprite:play(dmg_anim_speed, false,
                                function(s)
                                    s:remove(); TableUtils.removeValue(enemy.dmg_sprites, dmg_sprite)
                                end) -- Remove itself and Remove the dmg_sprite from the enemy's dmg_sprite table when its removed
                enemy.parent:addChild(dmg_sprite)

                local sound = enemy:getDamageSound() or "damage"
                if sound and type(sound) == "string" then
                    Assets.stopAndPlaySound(sound)
                end
                enemy:hurt(damage, battler)

                -- TODO: Call this even if damage is 0, will be a breaking change
                battler.chara:onAttackHit(enemy, damage)
            else
                enemy:hurt(0, battler, nil, nil, nil, action.points ~= 0)
            end

            for _, item in ipairs(battler.chara:getEquipment()) do
                item:onAttackHit(battler, enemy, damage)
            end

            self:finishAction(action)

            TableUtils.removeValue(self.normal_attackers, battler)
            TableUtils.removeValue(self.auto_attackers, battler)

            if not self:retargetEnemy() then
                self.cancel_attack = true
            elseif #self.normal_attackers == 0 and #self.auto_attackers > 0 then
                local next_attacker = self.auto_attackers[1]

                local next_action = self:getActionBy(next_attacker, true)
                if next_action then
                    self:beginAction(next_action)
                    self:processAction(next_action)
                end
            end
        end)

        return false
    elseif action.action == "ACT" then
        -- fun fact: this would have only been a single function call
        -- if stupid multi-acts didn't exist

        -- Check for other short acts
        local self_short = false
        self.short_actions = {}
        for _, iaction in ipairs(self.current_actions) do
            if iaction.action == "ACT" then
                local ibattler = self.party[iaction.character_id]
                local ienemy = iaction.target

                if ienemy then
                    local act = ienemy and ienemy:getAct(iaction.name)

                    if (act and act.short) or (ienemy:getXAction(ibattler) == iaction.name and ienemy:isXActionShort(ibattler)) then
                        table.insert(self.short_actions, iaction)
                        if ibattler == battler then
                            self_short = true
                        end
                    end
                end
            end
        end

        if self_short and #self.short_actions > 1 then
            local short_text = {}
            for _, iaction in ipairs(self.short_actions) do
                local ibattler = self.party[iaction.character_id]
                local ienemy = iaction.target

                local act_text = ienemy:onShortAct(ibattler, iaction.name)
                if act_text then
                    table.insert(short_text, act_text)
                end
            end

            self:shortActText(short_text)
        else
            local text = enemy:onAct(battler, action.name)
            if text then
                self:setActText(text)
            end
        end

        return false
    elseif action.action == "SKIP" then
        return true
    elseif action.action == "SPELL" then
        self.battle_ui:clearEncounterText()

        -- The spell itself handles the animation and finishing
        action.data:onStart(battler, action.target)

        return false
    elseif action.action == "ITEM" then
        local item = action.data
        if item.instant then
            self:finishAction(action)
        else
            local text = item:getBattleText(battler, action.target)
            if text then
                self:battleText(text)
            end
            battler:setAnimation("battle/item", function()
                local result = item:onBattleUse(battler, action.target)
                if result or result == nil then
                    self:finishAction(action)
                end
            end)
        end
        return false
    elseif action.action == "DEFEND" then
        battler:setAnimation("battle/defend")
        battler.defending = true
        return false
    else
        -- we don't know how to handle this...
        Kristal.Console:warn("Unhandled battle action: " .. tostring(action.action))
        return true
    end
end

function Battle:onVictory()
    self.current_selecting = 0

    if self.tension_bar then
        self.tension_bar:hide()
    end

    self:endWaves()

    for _, battler in ipairs(self.party) do
        battler:setSleeping(false)
        battler.defending = false
        battler.action = nil

        battler.chara:resetBuffs()

        if battler.chara:getHealth() <= 0 then
            battler:revive()
            battler.chara:setHealth(battler.chara:autoHealAmount())
        end

        battler:setAnimation("battle/victory")

        local box = self.battle_ui.action_boxes[self:getPartyIndex(battler.chara.id)]
        box:resetHeadIcon()
    end

    self.money = self.money --+ (math.floor((Game:getTension() / 10)))

    for _, battler in ipairs(self.party) do
        for _, equipment in ipairs(battler.chara:getEquipment()) do
            self.money = math.floor(equipment:applyMoneyBonus(self.money) or self.money)
        end
    end

    self.money = math.floor(self.money)

    self.money = self.encounter:getVictoryMoney(self.money) or self.money
    self.xp = self.encounter:getVictoryXP(self.xp) or self.xp

    -- if (in_dojo) then
    --     self.money = 0
    -- end

    Game.money = Game.money + self.money
    Game.xp = Game.xp + self.xp

    if (Game.money < 0) then
        Game.money = 0
    end

    local win_text = string.format("* Victory!\n* You got %s %s.", self.money, Game:getConfig("darkCurrency"))

    -- if (in_dojo) then
    --     win_text == "* You won the battle!"
    -- end

    if self.used_violence and Game:getConfig("growStronger") then
        local stronger = "You"

        local party_to_lvl_up = {}
        for _, battler in ipairs(self.party) do
            table.insert(party_to_lvl_up, battler.chara)
            if Game:getConfig("growStrongerChara") and battler.chara.id == Game:getConfig("growStrongerChara") then
                stronger = battler.chara:getName()
            end
            for _, id in pairs(battler.chara:getStrongerAbsent()) do
                table.insert(party_to_lvl_up, Game:getPartyMember(id))
            end
        end

        Game.level_up_count = Game.level_up_count + 1
        for _, party in ipairs(TableUtils.removeDuplicates(party_to_lvl_up)) do
            party:onLevelUp(Game.level_up_count)
        end

        win_text = string.format("* You won!\n* Got %s %s.\n* %s became stronger.", self.money,
                                 Game:getConfig("darkCurrencyShort"), stronger)
        Assets.playSound("dtrans_lw", 0.7, 2)
    end

    win_text = self.encounter:getVictoryText(win_text, self.money, self.xp) or win_text

    if self.encounter.no_end_message then
        self:setState("TRANSITIONOUT")
        self.encounter:onBattleEnd()
    else
        self:battleText(win_text, function()
            self:setState("TRANSITIONOUT")
            self.encounter:onBattleEnd()
            return true
        end)
    end
end

function Battle:drawBackground()
    Draw.setColor(0, 0, 0, self.transition_timer / 10)
    love.graphics.rectangle("fill", -8, -8, SCREEN_WIDTH + 16, SCREEN_HEIGHT + 16)

    love.graphics.setLineStyle("rough")
    love.graphics.setLineWidth(2) -- from 1


    for i = 2, 16 do
        Draw.setColor(66 / 255, 0, 66 / 255, (self.transition_timer / 10) * 0.25)
        love.graphics.line(0, -210 + (i * 50) + math.floor(self.offset / 2), 640,
                           -210 + (i * 50) + math.floor(self.offset / 2))
        love.graphics.line(-200 + (i * 50) + math.floor(self.offset / 2), 0,
                           -200 + (i * 50) + math.floor(self.offset / 2), 480)
    end

    for i = 3, 16 do
        Draw.setColor(66 / 255, 0, 66 / 255, (self.transition_timer / 10) * 0.5)
        love.graphics.line(0, -100 + (i * 50) - math.floor(self.offset), 640, -100 + (i * 50) - math.floor(self.offset))
        love.graphics.line(-100 + (i * 50) - math.floor(self.offset), 0, -100 + (i * 50) - math.floor(self.offset), 480)
    end

    love.graphics.setLineWidth(4)

    local x1, y1, x2, y2, x3, y3 = 80, 140 + (10 - self.transition_timer) * 30, 30, 270 + (10 - self.transition_timer) *
        30, 630, 580 + (10 - self.transition_timer) * 30
    Draw.setColor(0, 0, 0, self.transition_timer / 10)
    love.graphics.polygon("fill", x1, y1, x2, y2, x3, y2, y3, y1)





    --separate thing


    --[[    Draw.setColor(1,1,1, (self.transition_timer / 10))

    local newbg = love.graphics.newImage(Mod.info.path.."/assets/sprites/bullets/star_main1.png")
    local block_width = newbg:getWidth()
        local block_height = newbg:getHeight()
local block_depth = block_height/2

local grid_x = SCREEN_WIDTH/2
local grid_y = SCREEN_HEIGHT/2

local mygrid_size = 10
local mygrid = {}
for x = 1,mygrid_size do
   mygrid[x] = {}
   for y = 1,mygrid_size do
      mygrid[x][y] = 1
   end
end
for x = 1,mygrid_size do
   for y = 1,mygrid_size do
         love.graphics.draw(newbg,
            grid_x + ((y-x) * (block_width / 2)),
            grid_y + ((x+y) * (block_depth / 2)) - (block_depth * (mygrid_size / 2)))
   end
end]]


    if self.encounter.battleroom_upper then
        Draw.setColor(1, 1, 1, (self.transition_timer / 10))
        local function myStencilFunction()
            love.graphics.polygon("fill", x1, y1, x2, y2, x3, y2, y3, y1)
        end
        love.graphics.stencil(myStencilFunction, "replace")
        love.graphics.setStencilTest("greater", 0)
        local newbg = Assets.getTexture("battlerooms/upper/" .. self.encounter.battleroom_upper)
        love.graphics.draw(newbg, x2, y1)
        love.graphics.setStencilTest()
    end



    Draw.setColor(66 / 255, 0, 66 / 255, (self.transition_timer / 10))
    local g = 70
    local h = 4
    love.graphics.polygon("line", x1, y1, x2, y2, x3, y2, y3, y1)

    love.graphics.polygon("fill", x2 + h, y2, x3 - h, y2, x3 - g - h, SCREEN_WIDTH + 4, x2 + g + h, SCREEN_WIDTH + 4)
    -- isometric stuff is too hard in real time; jsut make the sprites themselves isometric. now easy w aseprite
end

-- just changes the soul color to be correct
function Battle:spawnSoul(x, y)
    local bx, by = self:getSoulLocation()
    local color = { self.encounter:getSoulColor() }
    self:addChild(HeartBurst(bx, by, color))
    if not self.soul then
        self.soul = self.encounter:createSoul(bx, by, color)
        self.soul:transitionTo(x or SCREEN_WIDTH / 2, y or SCREEN_HEIGHT / 2)
        --      self.soul.target_alpha = self.soul.alpha --why is this here
        self.soul.alpha = 0
        if Game:getConfig("soulInvBetweenWaves") then
            self.soul.inv_timer = Game.old_soul_inv_timer
        end
        Game.old_soul_inv_timer = 0
        self:addChild(self.soul)
    end

    if self.state == "DEFENDINGBEGIN" or self.state == "DEFENDING" then
        self.soul:onWaveStart()
    end
end

return Battle
