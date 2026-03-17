--removing any light world references to reduce headaches of adding stuff
--added new image, death sounds, and dpiscale
local GameOver, super = HookSystem.hookScript(GameOver)

function GameOver:init(x, y)
    super.super.init(self, 0, 0)

    self.font = Assets.getFont("main")
    self.soul_blur = Assets.getTexture("player/heart_blur")

    if not Game:isLight() then
        -- self.screenshot = love.graphics.newImage(SCREEN_CANVAS:newImageData())
        self.screenshot = love.graphics.newImage(SCREEN_CANVAS:newImageData(), {
            dpiscale = SCREEN_CANVAS:getDPIScale()
        })
    end

    self.music = Music()

    self.soul = Sprite("player/heart")
    self.soul:setScale(0.25, 0.25)
    self.soul:setOrigin(0.5, 0.5)
    self.soul:setColor(Game:getSoulColor())
    self.soul.x = x
    self.soul.y = y

    self:addChild(self.soul)

    self.current_stage = 0
    self.fader_alpha = 0
    self.skipping = 0
    self.fade_white = false

    self.timer = 0

    if Game:isLight() then
        self.timer = 28 -- We only wanna show one frame if we're in Undertale mode
    end
end

function GameOver:update()
    super.super.update(self)
    local extra_time = 10

    self.timer = self.timer + DTMULT
    if (self.timer >= 30) and (self.current_stage == 0) then
        self.screenshot = nil
        self.current_stage = 1
    end
    if (self.timer >= 50) and (self.current_stage == 1) then
        Assets.playSound("break1")
        self.soul:setSprite("player/heart_break")
        self.soul:setScale(0.25, 0.25)
        self.current_stage = 2
    end
    if (self.timer >= 90) and (self.current_stage == 2) then
        Assets.playSound("break2")

        local shard_count = 6
        local x_position_table = { -2, 0, 2, 8, 10, 12 }
        local y_position_table = { 0, 3, 6 }

        self.shards = {}
        for i = 1, shard_count do
            local x_pos = x_position_table[((i - 1) % #x_position_table) + 1]
            local y_pos = y_position_table[((i - 1) % #y_position_table) + 1]
            local shard = Sprite("player/heart_shard", self.soul.x + x_pos, self.soul.y + y_pos)
            shard:setColor(self.soul:getColor())
            shard.physics.direction = math.rad(MathUtils.random(360))
            shard.physics.speed = 7
            shard.physics.gravity = 0.2
            shard:play(5 / 30)
            table.insert(self.shards, shard)
            self:addChild(shard)
        end

        self.soul:remove()
        self.soul = nil
        self.current_stage = 3
        Assets.playSound("death/" .. math.random(1, 7), 1.8)
    end
    if (self.timer >= 140 + extra_time) and (self.current_stage == 3) then
        if Game:isLight() then
            self.fader_alpha = 0
            self.current_stage = 4
        else
            self.fader_alpha = (self.timer - (140 + extra_time)) / 10
            if self.fader_alpha >= 1 then
                for i = #self.shards, 1, -1 do
                    self.shards[i]:remove()
                end
                self.shards = {}
                self.fader_alpha = 0
                self.current_stage = 4
            end
        end
    end
    if (self.timer >= 150 + extra_time) and (self.current_stage == 4) then
        self.music:play(Game:isLight() and "determination" or Game:getConfig("oldGameOver") and "AUDIO_DRONE" or
            "AUDIO_DEFEAT")
        if not Game:getConfig("oldGameOver") or Game:isLight() then
                self.text = Sprite("gameover/gameover", 0, 40)
                self.text:setScale(2)

            self.finger = JawshFinger(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 3)
            self.finger.alpha = 0
            self:addChild(self.finger)
            self.finger:fadeTo(1+2/3)

            self.alpha = 0
            self:addChild(self.text)
            self.text:setColor(1, 1, 1, self.alpha)


        end
        self.current_stage = 5
    end
    if ((self.timer >= (Game:isLight() and 230 + extra_time or 180 + extra_time))) and (self.current_stage == 5) then
        local options = {}
        local main_chara = Game:getSoulPartyMember()
        for _, member in ipairs(Game.party) do
            if member:getGameOverMessage(main_chara) then
                table.insert(options, member)
            end
        end
        if Game:getConfig("oldGameOver") and not Game:isLight() then
            if Game.died_once then
                self.current_stage = 6
            else
                self.dialogue = DialogueText(
                    "[speed:0.5][spacing:8][voice:none]IT APPEARS YOU\nHAVE REACHED[wait:30]\n\n   AN END.", 160, 160,
                    { style = "GONER", line_offset = 14 })
                self.dialogue.skip_speed = true
                self:addChild(self.dialogue)
                self.current_stage = 6
            end
        elseif #options == 0 then
            if Game:isLight() then
                if Input.pressed("confirm") or Input.pressed("menu") then
                    self.music:fade(0, 2)
                    self.current_stage = 10
                    self.timer = 0
                end
            else
                self.current_stage = 7
            end
        else
            local member = TableUtils.pick(options)
            local voice = member:getActor().voice or "default"
            self.lines = {}
            --removed the ability to have multiple lines in gameover, so multiple ones can be pulled instead
            --for _, dialogue in ipairs(member:getGameOverMessage(main_chara)) do
                local spacing = Game:isLight() and 6 or 8
                local full_line = "[speed:0.5][spacing:" .. spacing .. "][voice:" .. voice .. "]"..member:getGameOverMessage(main_chara)
                --[[local lines = StringUtils.split(dialogue, "\n")
                for i, line in ipairs(lines) do
                    if i > 1 then
                        full_line = full_line .. "\n  " .. line
                    else
                        full_line = full_line .. "  " .. line
                    end
                end]]
                table.insert(self.lines, full_line)
            --end
            self.dialogue = DialogueText(
                self.lines[1], 0, 300,
                {
                    style = "none",
                    align = "center",
                    actor = member:getActor(Game:isLight())
                })

                self.dialogue.skip_speed = true
                self.dialogue.line_offset = 14
            self:addChild(self.dialogue)
            table.remove(self.lines, 1)
            self.current_stage = 6
        end
    end
    if (self.current_stage == 6) and Input.pressed("confirm") and (not self.dialogue:isTyping()) then
        if not Game:getConfig("oldGameOver") or Game:isLight() then
            if #self.lines > 0 then
                self.dialogue:setText(self.lines[1])
                self.dialogue.line_offset = 14
                table.remove(self.lines, 1)
            else
                self.dialogue:remove()
                self.current_stage = 7
                if Game:isLight() then
                    self.music:fade(0, 2)
                    self.current_stage = 10
                    self.timer = 0
                end
            end
        else
            self.dialogue:setText("[speed:0.5][spacing:8][voice:none]WILL YOU TRY AGAIN?")
            self.dialogue.x = 100
            self.current_stage = 7
        end
    end
    if Game:getConfig("oldGameOver") and self.current_stage == 6 and Game.died_once then
        self.dialogue = DialogueText("[speed:0.5][spacing:8][voice:none]WILL YOU PERSIST?", 120, 160,
                                     { style = "GONER", line_offset = 14 })
        self:addChild(self.dialogue)
        self.current_stage = 7
    end

    if (self.current_stage == 7) then
        if not Game:getConfig("oldGameOver") then
            self.choicer = GonerChoice(160, 360, {
                { { "CONTINUE", 0, 0 }, { "<<" }, { ">>" }, { "END STREAM", 220, 0 } }
            })
            self.choicer:setSelectedOption(2, 1)
            self.choicer:setSoulPosition(140, 0)
        else
            self.choicer = GonerChoice(220, 360, {
                { { "YES", 0, 0 }, { "<<" }, { ">>" }, { "NO", 160, 0 } }
            })
            self.choicer:setSelectedOption(2, 1)
            self.choicer:setSoulPosition(80, 0)
        end
        self:addChild(self.choicer)
        self.current_stage = 8
    end

    if (self.current_stage == 8) then
        if self.choicer.choice then
            self.music:stop()

            if self.choicer.choice_x == 1 then
                self.current_stage = 9
                self.timer = 0
            else
                self.current_stage = 20

                self.finger:play(1, true)
                self.finger:fadeTo(0, 2, function()
                    self.finger:addFX(ShaderFX("grayscale"))
                    self.finger:fadeTo(0.8, 2)
                end)

                local world_ended_text =
                "[noskip][speed:0.5][spacing:8][voice:none] THEN THE WORLD[wait:30] \n WAS LOST[wait:30] \n WITHOUT YOU."
                if not Game:getConfig("oldGameOver") then
                    self.text:remove()
                    self.dialogue = DialogueText(world_ended_text, 0, 160, { style = "GONER", line_offset = 12, align = "center" })
                    self:addChild(self.dialogue)
                else
                    self.dialogue:setText(world_ended_text)
                end
            end
        end
    end

    if (self.current_stage == 9) then
        if Game:getConfig("oldGameOver") then
            if Game.died_once then
                self.dialogue:setText("")
            else
                self.dialogue:setText("[noskip][speed:0.5][spacing:8][voice:none] THEN, THE FUTURE\n IS IN YOUR HANDS.")
            end
        end
        if (self.timer >= 30) then
            self.timer = 0
            self.current_stage = 10
            if not Game:getConfig("oldGameOver") then
                local sound = Assets.newSound("dtrans_lw")
                sound:play()
            end
            self.fade_white = true
        end
    end

    if (self.current_stage == 10) then
        self.fade_white = not Game:isLight()
        self.fader_alpha = self.fader_alpha +
            ((Game:isLight() and 0.02 or Game:getConfig("oldGameOver") and Game.died_once and 0.03 or 0.01) * DTMULT)
        if self.timer >= (Game:isLight() and 80 or Game:getConfig("oldGameOver") and Game.died_once and 40 or 120) then
            if Game:getConfig("oldGameOver") and not Game:isLight() then Game.died_once = true end
            self.current_stage = 11
            Game:loadQuick()
            if Game:isLight() then
                Game.fader:fadeIn(nil,
                                  { alpha = 1, speed = 12 / 30, color = self.fade_white and { 1, 1, 1 } or { 0, 0, 0 } })
            end
        end
    end

    if (self.current_stage == 20) and Input.pressed("confirm") and (not self.dialogue:isTyping()) then
        self.dialogue.alpha = 0
        local fade_speed = 34
        self.dialogue:fadeTo(1, fade_speed, function()
            self.dialogue:fadeOutAndRemove(fade_speed)
        end)
        self.dialogue:setPosition(0, SCREEN_HEIGHT * 0.85)
        self.dialogue:setText("[noskip][speed:0.00227][spacing:64][voice:none]RIP")
        -- self.dialogue:remove()

        self.music:play("AUDIO_DARKNESS") -- find a time where he says this game sucks replace with this

        self.finger.faded = true


        self.music.source:setLooping(false)
        self.current_stage = 21
    end

    if (self.current_stage == 21) and (not self.music:isPlaying()) then
        self.finger:remove()
        if Kristal.getModOption("hardReset") then
            love.event.quit("restart")
        else
            Kristal.returnToMenu()
        end
        self.current_stage = 0
    end

    if ((self.timer >= 80) and (self.timer < 150)) then
        if Input.pressed("confirm") then
            self.skipping = self.skipping + 1
        end
        if (self.skipping >= 4) then
            Game:loadQuick()
        end
    end

    if self.text then
        self.alpha = self.alpha + (0.02 * DTMULT)
        self.text:setColor(1, 1, 1, self.alpha)
    end
end

function GameOver:onKeyPressed(key)
    -- ?
end

return GameOver
