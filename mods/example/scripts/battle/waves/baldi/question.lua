local Question, super = Class(Wave)

function Question:init()
    super.init(self)
    self:setArenaRotation(math.pi / 4)
    self.time = 6
    self.answers = {}
    self.selected_answer = nil
end

--add textboxes. they are objects!
function Question:onStart()
    local arena = Game.battle.arena
    Draw.setColor(0, 1, 0, 0.25)
    local divider1 = Sprite("bullets/pixel", 0, 0)
    divider1:setColor(0, 1, 0, 0.25)
    divider1:setScale(200, 1)
    divider1.rotation = math.pi / 4
    Game.battle.arena:addChild(divider1)
    local divider2 = Sprite("bullets/pixel", arena.width, 0)
    divider2:setColor(0, 1, 0, 0.25)
    divider2:setScale(200, 1)
    divider2.rotation = 3 * math.pi / 4
    Game.battle.arena:addChild(divider2)

    local question = math.random(0, 3)
    local number = 0
    local number2 = 0
    local answer = 0
    self.timer:after(0.4, function()
        if question == 0 then
            number = math.random(2, 5)
            local function factorial(num)
                local result = 1
                for i = 1, num do
                    result = result * i
                end
                return result
            end
            answer = factorial(number)
            self.answers = { answer, factorial(number - 1), factorial(number + 1), answer + math.random(1, 5) }
            Game.battle:infoText("                " .. number .. "! = ?")
        elseif question == 1 then
            number = math.random(7, 10)
            answer = number
            self.answers = { answer, answer + 1, answer - 1, answer - 2 }
            local question = "1 = ?"
            for num = 1, number - 1 do
                question = StringUtils.insert(question, "1+", 0)
                Game.battle:infoText("         " .. question)
            end
        elseif question == 2 then
            number = math.random(0, 10)
            number2 = math.random(0, 10)
            answer = number * number2
            self.answers = { answer, (number + 1) * number2, answer + math.random(1, 8), answer - math.random(1, 8) }
            Game.battle:infoText("               " .. number .. "x" .. number2 .. " = ?")
        elseif question == 3 then
            number = math.random(0, 10)
            number2 = math.random(0, 10)
            answer = number + number2
            local stupid = 21
            answer = number + number2
            self.answers = { answer, answer + 2, answer + math.random(1, 5), answer - math.random(1, 5) }
            Game.battle:infoText("               " .. number .. "+" .. number2 .. " = ?")
        end
        self.answers = TableUtils.shuffle(self.answers)
        local text_offset_x, text_offset_y = -10, -10
        local choice1 = Text(self.answers[1], Game.battle.arena.width / 2 + text_offset_x - 50,
                             Game.battle.arena.height / 2 + text_offset_y + 0, 40, 20, { font_size = 24 })
        choice1.rotation = -math.pi / 4
        Game.battle.arena:addChild(choice1)
        local choice2 = Text(self.answers[2], Game.battle.arena.width / 2 + text_offset_x - 10,
                             Game.battle.arena.height / 2 + text_offset_y - 30, 40, 20, { font_size = 24 })
        choice2.rotation = -math.pi / 4
        Game.battle.arena:addChild(choice2)
        local choice4 = Text(self.answers[3], Game.battle.arena.width / 2 + text_offset_x - 10,
                             Game.battle.arena.height / 2 + text_offset_y + 60, 40, 20, { font_size = 24 })
        choice4.rotation = -math.pi / 4
        Game.battle.arena:addChild(choice4)
        local choice3 = Text(self.answers[4], Game.battle.arena.width / 2 + text_offset_x + 40,
                             Game.battle.arena.height / 2 + text_offset_y + 10, 40, 20, { font_size = 24 })
        choice3.rotation = -math.pi / 4
        Game.battle.arena:addChild(choice3)
        local choices = {choice1,choice2,choice3,choice4}

        self.timer:after(4, function()
            Assets.playSound("ruler_slap", 1)
            for i, choice in ipairs(choices) do
                if choice.text == answer then
                    self:spawnBullet("baldi/ruler_question", arena.x, arena.y, 2*i*math.pi/4)
                    self:spawnBullet("baldi/ruler_question", arena.x, arena.y, 2*i*math.pi/4+math.pi/2)
                end
            end
            if self.selected_answer == answer then
                Game.battle:infoText("             Great job!")
                self.timer:after(0.4, function()
                    Assets.playSound("sparkle_gem")
                end)
            else
                Game.battle:infoText("                 >:(")
                self.timer:after(0.4, function()
                    Assets.playSound("error")
                end)
            end
        end)
    end)
end

function Question:update()
    local soul = Game.battle.soul
    local arena = Game.battle.arena

    local choice_angle = MathUtils.angle(arena.x, arena.y, soul.x, soul.y)
    if choice_angle < 0 and choice_angle >= -math.pi / 2 then
        self.selected_answer = self.answers[2]
    elseif choice_angle < -math.pi / 2 and choice_angle >= -math.pi then
        self.selected_answer = self.answers[1]
    elseif choice_angle <= math.pi and choice_angle > math.pi / 2 then
        self.selected_answer = self.answers[3]
    else
        self.selected_answer = self.answers[4]
    end

    super.update(self)
end

return Question
