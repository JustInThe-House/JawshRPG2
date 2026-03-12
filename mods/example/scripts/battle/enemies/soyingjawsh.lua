local SoyingJawsh, super = Class(EnemyBattler)

function SoyingJawsh:init()
    super.init(self)

    self.siner = 0
    self.alternator = 0
    self.afterimaging = true
    self.time_afterimage = 0
    self.fadeback = false

    self.xstart = 522 -- taken from encounter file
    self.ystart = 270

    -- Enemy name
    self.name = "\"Jawsh\""
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/SoyingJawsh.lua)
    self:setActor("soyingjawsh")

    self.arm = soyingjawsh_arm(61, 47)
    self:addChild(self.arm)
    self.arm.layer = self.layer - 1

    -- Enemy health
    self.max_health = 4500
    self.health = 4500
    -- Enemy attack (determines bullet damage)
    self.attack = 1 -- 10
    -- Enemy defense (usually 0)
    self.defense = 4
    -- Enemy reward
    self.money = 100

    self.graze_tension = 1.6 --0 means no graze

    self.holdbreath = 0
    self.plea = 0
    self.checked = false
    -- self.enraged = false
    self.timer_soying = 0
    self.soying = false
    self.difficulty_step = 0

    self.swooned_text = { false, false, false }

    self.lowhealth_threshold = 0.5
    self.medhealth_threshold = 0.66
    self.highhealth_threshold = 0.83

    self.cycle = 0
    self.special = 0

    self.manual_move = false
    self.afterimage_strength = 0

    -- self:setScale(2,2)

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "starshot"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {}

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "Jawsh tried analyzing further,[wait:7]\nbut couldn't think straight."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* A wind\n      A storm\n             A story.",
        "* Your mind goes numb.",
        "* Your vision blurs.",
        "* Your feel sick to your stomach.",
        "* You feel cornered.",
        "* Your head is spinning.",
    }

    self.text_medhealth = {
        "* A blast\n       Of air\n             You stagger.",
        "* Your mind is in stasis.",
        "* Your vision doubles.[speed:0.1]..?[speed:0.1]",
        "* Your hear your heartbeat\npounding in your head.",
        "* A moment of serenity,[wait:5]\nfollowed by absolute panic.",
        "* Your head is spinning.\n * ...Another migraine is coming on...",
    }
    self.text_lowhealth = {
        "* And now\n       The ends\n               Colliding.",
        "* Your mind goes violet.",
        --   "* The Pibby glitch surrounds you.", -- not best used here.
        "* You feel your body splitting in two.",
        --  "* You blink in and out of consciousness.",
        "* For a moment,[wait:5] you heard the sound\nof children crying.",
        "* The virulent miasma makes you TUH.",
        "* Your head is spinning.\n* ...[wait:5]The world revolves around Jawsh.",
    }
    self.text_soying = {
        "* You feel pain in your left arm.",
        "* The Jawsh's mouth glows a weird purple hue...",
        "* The Jawsh let down its soy guard!",

        "* Berd grew a paler shade of white.",
    }
    self.text_ondeath = {
        "* Jawsh reached for his HEART.\n",
        "* Berd fell to the corruption.",
        "* Vinny melted into a pile of hemorrhoids.",
    }
    self.text_special = {
        "* You felt many eyes watching your every move...",
        "* Jawsh smiled. Jawsh smiled, too.",
    }
    self:registerAct("Hold Breath")
end

function SoyingJawsh:onAct(battler, name)
    if name == "Check" then
        if not self.checked then
            self.checked = true
            return "* Jawsh tried analyzing the enemy,[wait:5]\nbut couldn't think straight."
        else
            return "* Jawsh pointed into the haze.[wait:9]\nNothing happened."
        end
    elseif name == "Hold Breath" then
        self.holdbreath = self.holdbreath + 1
        if self.holdbreath == 1 then
            battler.chara:addStatBuff("soul_speed", 0.1)
            return {
                "* Jawsh held his breath.[wait:5]\n* His heartbeat quickened.[wait:5]\n* The HEART moves faster.",
            }
        elseif self.holdbreath == 2 then
            battler.chara:addStatBuff("soul_speed", 0.1)

            return {
                "* Jawsh held his breath.[wait:5]\n* He started feeling woozy.[wait:5]\n* The HEART moves faster.",
            }
        else
            return {
                "* Jawsh held his breath...[wait:5]\n ...and almost passed out.[wait:5]\n* Nothing else happened.",
            }
        end
    elseif name == "Standard" then
        if battler.chara.id == "vinny" then
            if self.plea == 0 then
                Game.battle:startActCutscene("plea", "plea1")
            else
                Game.battle:startActCutscene("plea", "plea2")
            end
            self.plea = self.plea + 1

            return
        elseif battler.chara.id == "berd" then
            Game.battle:startActCutscene("SoyingJawsh", "threaten")
            battler.chara.has_xact = false -- this removes the act. would have to update after this. this is permanent!
            return
        else
            return
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

function SoyingJawsh:onTurnEnd()
    if Game.battle.party[1].is_down and self.holdbreath > 0 then
        Game.party[1]:addStatBuff("soul_speed", -math.min(0.2, 0.1 * self.holdbreath))
        self.holdbreath = 0
    end
end

function SoyingJawsh:onHurt(amount, battler)
    super.onHurt(self, amount, battler)
    if self.health < self.max_health * self.highhealth_threshold and self.difficulty_step < 1 then
        self.difficulty_step = 1
        self.afterimage_strength = 0.75
        Game.battle.encounter.difficulty = 1
    elseif self.health < self.max_health * self.medhealth_threshold and self.difficulty_step < 2 then
        self.difficulty_step = 2
        Game.battle.encounter.difficulty = 2
        self.afterimage_strength = 1.25
    end
end

function SoyingJawsh:selectWave()
    local turn = ((Game.battle.turn_count - 1) % 5) + 1 - self.special
    --Kristal.Console:log(Utils.dump({ Game.battle.turn_count, turn }))

    -- Select specific waves based on the turn
    if Game.battle.encounter.difficulty == 0 then
        if turn == 1 then
            self.selected_wave = "starshot"
            return self.selected_wave
        elseif turn == 2 then
            self.selected_wave = "moving_swords"
            return self.selected_wave
        elseif turn == 3 then
            self.selected_wave = "boxcut"
            return self.selected_wave
        elseif turn == 4 then
            self.selected_wave = "tunnel_cardinal"
            return self.selected_wave
        elseif turn == 5 then
            self.cycle = self.cycle + 1
            self.selected_wave = "rotating_slash"
            return self.selected_wave
        end
    elseif Game.battle.encounter.difficulty == 1 then
        if turn == 1 then
            self.selected_wave = "starshot"
            return self.selected_wave
        elseif turn == 2 then
            self.selected_wave = "moving_swords_circle"
            return self.selected_wave
        elseif turn == 3 then
            self.selected_wave = "boxcut"
            return self.selected_wave
        elseif turn == 4 then
            self.selected_wave = "tunnel_360"
            return self.selected_wave
        elseif turn == 5 then
            self.selected_wave = "rotating_slash"
            return self.selected_wave
        end
    elseif Game.battle.encounter.difficulty == 2 then
        if turn == 1 then
            self.selected_wave = "starshot"
            return self.selected_wave
        elseif turn == 2 then
            self.selected_wave = "moving_swords_fast"
            return self.selected_wave
        elseif turn == 3 then
            self.selected_wave = "boxcut"
            return self.selected_wave
        elseif turn == 4 then
            self.selected_wave = "tunnel_cardinal"
            return self.selected_wave
        elseif turn == 5 then
            self.selected_wave = "rotating_slash"
            return self.selected_wave
        end
    end
    -- Use random wave selection when the script runs out (assuming self.waves is set)
    return super.selectWave(self)
end

function SoyingJawsh:getEncounterText()
    for _, battler in ipairs(Game.battle.party) do
        --   Kristal.Console:log(battler.chara:getStat("down_count"))
        if battler.chara:getStat("down_count") > 0 and battler.is_down then
            if battler.chara.id == "jawsh" and not self.swooned_text[1] then
                self.swooned_text[1] = true
                return (self.text_ondeath[1] .. ((self.holdbreath > 0 and "[wait:5]* Hold Breath was reset.") or ""))
            elseif battler.chara.id == "berd" and not self.swooned_text[2] then
                self.swooned_text[2] = true
                return self.text_ondeath[2]
            elseif battler.chara.id == "vinny" and not self.swooned_text[3] then
                self.swooned_text[3] = true
                return self.text_ondeath[3]
            end
        end
    end
    local turn = Game.battle.turn_count - 1
    if turn == 1 then
        return self.text_special[1]
    elseif self.health >= self.max_health * self.highhealth_threshold then
        return self.text[(turn % #self.text) + 1]
    elseif self.health >= self.max_health * self.medhealth_threshold then
        return self.text_medhealth[(turn % #self.text_medhealth) + 1]
    elseif self.health >= self.max_health * self.lowhealth_threshold then
        return self.text_lowhealth[(turn % #self.text_lowhealth) + 1]
    elseif self.health < self.max_health * 0.5 and not self.soying then
        self.timer_soying = self.timer_soying + 1
        return self.text_soying[self.timer_soying]
    else
        return TableUtils.pick(self.text_medhealth)
    end
end

function SoyingJawsh:update()
    --[[if Game.battle.music ~= nil then
    Kristal.Console:log(Game.battle.music:tell())
    end]]
    if not self.manual_move then
        self.siner = self.siner + DTMULT
    end
    if self.afterimaging then
        self.time_afterimage = self.time_afterimage + DTMULT
    end
    if not self.manual_move then
        self.y = self.ystart + 20 * math.sin(math.rad(4.5 * self.siner))
    end
    if self.time_afterimage > 3 then
        local afterimage_fade = 0.015
        local afterimage_alpha = 0.4
        local afterimage_speed = 1.5
        local afterimage_friction = 0
        if self.fadeback then
            afterimage_fade = 0.05
            afterimage_alpha = 1
            afterimage_speed = -1
            afterimage_friction = -1
        end
        if self.sprite.alpha ~= 0 then
            local after_image1 = AfterImage(self.sprite, afterimage_alpha, afterimage_fade)
            self.parent:addChild(after_image1)
            if self.sprite.anim == "point" then
                after_image1.physics.speed_y = afterimage_speed * self.alternator
                self.alternator = self.alternator * -1
            end
            after_image1.physics.speed_x = afterimage_speed
            after_image1.physics.friction = afterimage_friction
        end
        if self.arm.alpha ~= 0 then
            local after_image2 = AfterImage(self.arm, afterimage_alpha, afterimage_fade)
            self.parent:addChild(after_image2)
            if self.sprite.anim == "point" then
                after_image2.physics.speed_y = afterimage_speed * self.alternator
            end
            after_image2.physics.speed_x = afterimage_speed
            after_image2.physics.friction = afterimage_friction
        end

        for _, battler in ipairs(Game.battle.party) do
            local after_image_battlers = AfterImage(battler, 0.4, 0.03)
            self.parent:addChild(after_image_battlers)
            if self.health < self.max_health * self.highhealth_threshold then
                local angle_to_jawsh = Utils.angle(battler, self)
                after_image_battlers.physics.speed_x = self.afterimage_strength * math.cos(2 * angle_to_jawsh)
                after_image_battlers.physics.speed_y = self.afterimage_strength * math.sin(2 * angle_to_jawsh)
                -- after_image_battlers:setColor() i think i want to fade it to purple at some point?
            end
        end
        self.time_afterimage = 0
    end

    super.update(self)
end

function SoyingJawsh:onHurt(damage, battler)
    super.onHurt(self, damage, battler)
    if damage > 100 and self.flipping == nil then
        Game.battle.timer:tween(0.3, self.arm,
                                { scale_x = -0.25, alpha = 0.5, rotation = self.rotation + math.pi / 4 }, "linear",
                                function()
                                    Game.battle.timer:tween(0.3, self.arm,
                                                            {
                                                                scale_x = 0.25,
                                                                alpha = 1,
                                                                rotation = self.rotation -
                                                                    math.pi / 4
                                                            })
                                end)

        Game.battle.timer:tween(0.3, self, { scale_x = -2, alpha = 0.5 }, "linear", function()
            Game.battle.timer:tween(0.3, self, { scale_x = 2, alpha = 1 })
            self.flipping = nil
        end)
    end
end

return SoyingJawsh
