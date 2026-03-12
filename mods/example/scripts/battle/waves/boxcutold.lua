local boxcutold, super = Class(Wave)

function boxcutold:init()
    super.init(self)
    Game.battle.encounter.difficulty = 2
    --self:setArenaOffset(-60,42)
    --self:setArenaRotation(78)
    self:setArenaSize(144, 144)

    self.arena2 = Arena(SCREEN_WIDTH / 2, (SCREEN_HEIGHT - 155) / 2 + 10,
        { { 0, 0 }, { 144, 0 }, { 144, 144 }, { 0, 144 } })
    self.arena2.rotation = math.rad(180)
    self.arena2.layer = BATTLE_LAYERS["arena"]

    Game.battle:addChild(self.arena2)

    --  Kristal.Console:log(self.arena2.y)
    --self:setArenaShape({0, 0}, {144, 0}, {0, 144})

    self.time = 13
    self.rate_box = 25
    self.stretching = false
    self.siner2 = 0
    self.siner = Utils.random(0, 6)
    self.cooldown = 50
    self.rand = Utils.pick({ 0, 1 })
    self.push_soul = 7
    self.spacing = 12
    local focus_pick = Utils.pick({ "vertical_slash", "horizontal_slash" })
    if Game.battle.encounter.difficulty == 0 then
        if self.rand == 0 then
            --  self.pick_table = {"vertical_slash","vertical_slash","vertical_slash","vertical_slash","vertical_slash","vertical_slash","vertical_slash","vertical_slash",}
            self.pick_table = { "horizontal_slash", "horizontal_slash", "horizontal_slash", "horizontal_slash",
                "horizontal_slash", "horizontal_slash", "horizontal_slash", "horizontal_slash", }
        else
            self.pick_table = { "horizontal_slash", "horizontal_slash", "horizontal_slash", "horizontal_slash",
                "horizontal_slash", "horizontal_slash", "horizontal_slash", "horizontal_slash", }
        end
    elseif Game.battle.encounter.difficulty == 1 then
        self.pick_table = { "vertical_slash", "vertical_slash", "horizontal_slash", "horizontal_slash", focus_pick,
            focus_pick, focus_pick, Utils.pick({ "vertical_slash", "horizontal_slash" }) }
    else
        --   self.pick_table = {"forward_slash","back_slash",Utils.pick({"forward_slash","back_slash"}),focus_pick,focus_pick,focus_pick,Utils.pick({"vertical_slash","horizontal_slash"}),Utils.pick({"vertical_slash","horizontal_slash"})}
        self.pick_table = { "forward_slash", "forward_slash", "forward_slash", "forward_slash", "forward_slash",
            "forward_slash", "forward_slash", "forward_slash" }
    end
    self.lined = false
    self.bulleted = false
    self.approach = 0
    self.stretch_length = 42
    self.arena_start_x, self.arena_start_y = 320, 172 -- INTITAL AREA COORDINATES DEFAULT
end

function boxcutold:update()
    self.rate_box = self.rate_box + DTMULT

    if self.rate_box >= 30 and not self.lined then
        self.lined = true
        self.pick = Utils.pick(self.pick_table, false, true)

        if self.pick == "horizontal_slash" then
            self.warning_slash = self:spawnBullet("sword_trail", self.arena_start_x, self.arena_start_y, 0, 0, "slash",
                { 0.8, 0, 0.8 })
        elseif self.pick == "vertical_slash" then
            self.warning_slash = self:spawnBullet("sword_trail", self.arena_start_x, self.arena_start_y, math.rad(90), 0,
                "slash", { 0.8, 0, 0.8 })
        elseif self.pick == "forward_slash" then
            self.warning_slash = self:spawnBullet("sword_trail", self.arena_start_x, self.arena_start_y, math.rad(-45), 0,
                "slash", { 0.8, 0, 0.8 })
        else
            self.warning_slash = self:spawnBullet("sword_trail", self.arena_start_x, self.arena_start_y, math.rad(45), 0,
                "slash", { 0.8, 0, 0.8 })
        end
    end
    if self.rate_box >= 60 then
        self.slash_angle = self.warning_slash.rotation

        if self.warning_slash.rotation ~= nil then
            Kristal.Console:log(self.warning_slash.rotation)
        end

        if self.lined then
            self.pick2 = self.pick
            --   self:setArenaShape({0, 0}, {142, 0},{142, 142}, {0, 142})
        end
        self.lined = false
        local after_image1, after_image2 = AfterImage(Game.battle, 0.4, 0.02), AfterImage(Game.battle, 0.4, 0.02)
        self:addChild(after_image1)
        self:addChild(after_image2)
        if self.pick2 == "horizontal_slash" then
            after_image2.physics.speed_y = -10
            after_image1.physics.speed_y = 10
        elseif self.pick2 == "vertical_slash" then
            after_image1.physics.speed_x = 10
            after_image2.physics.speed_x = -10
        elseif self.pick2 == "forward_slash" then
            after_image1.physics.speed_x = 10
            after_image2.physics.speed_x = -10
            after_image2.physics.speed_y = -10
            after_image1.physics.speed_y = 10
        else
            after_image1.physics.speed_x = 10
            after_image2.physics.speed_x = -10
            after_image2.physics.speed_y = 10
            after_image1.physics.speed_y = -10
        end
        if self.pick2 == "horizontal_slash" then
            self:setArenaShape({ 0, 0 }, { 144, 0 },{ 144, 72 + 72 * math.sin(self.slash_angle) }, { 0, 72 - 72 * math.sin(self.slash_angle) })
            self.arena2:setShape({ { 0, 0 }, { 144, 0 }, { 144, 72 + 72 * math.sin(self.slash_angle) }, { 0, 72 - 72 * math.sin(self.slash_angle) } })
        elseif self.pick2 == "vertical_slash" then
            self:setArenaShape({ 0, 0 }, { 72 - 72 * math.cos(self.slash_angle), 0 }, { 72 + 72 * math.cos(self.slash_angle), 144 }, { 0, 144 })
            self.arena2:setShape({ { 0, 0 }, { 72 - 72 * math.cos(self.slash_angle), 0 }, { 72 + 72 * math.cos(self.slash_angle), 144 }, { 0, 144 } })
        else
      --      self:setArenaShape({ 0, 0 }, { 72 + 72 * math.cos(self.slash_angle), 0 },{ 72 - 72 * math.cos(self.slash_angle), 144}, { 0, 144 })
                        self:setArenaShape({ 0, 0 }, { 144, 0 }, { 0, 144 })

    --        self.arena2:setShape({ { 0, 0 }, { 72 + 72 * math.cos(self.slash_angle+(math.pi/4)), 0 }, { 72 - 72 * math.cos(self.slash_angle+(math.pi/4)),144 }, { 0, 144 } }) for some reason this makes the walls disappear. USE THIS!
    --after doing it, the vertex disappears, but the hitbox is still there. unfortunately cant deal triangulation of the arena, so kinda stuck. you could
          --  self.arena2:setShape({{ 72 + 72 * math.cos(self.slash_angle+(math.pi/4)), 0 },{ 0, 0 },{ 0, 144 }, { 72 - 72 * math.cos(self.slash_angle+(math.pi/4)),144 } })
            self.arena2:setShape({ { 0, 0 }, { 144, 0 }, { 0, 144 } })


        end
        self.stretching = true
        self.soul_start_x, self.soul_start_y = Game.battle.soul.x, Game.battle.soul.y
        self.rate_box = self.rate_box - self.cooldown
    end


    if self.stretching then
        self.siner2 = self.siner2 + DTMULT

        if self.siner2 >= 3 and not self.bulleted then
            local sound = Assets.newSound("air_slash")
            sound:setPitch(1)
            sound:play()
            Game.battle.arena:shake(Utils.pick({ -1, 1 }), Utils.pick({ -1, 1 }), 0, 2 / 30)
            self.arena2:shake(Utils.pick({ -1, 1 }), Utils.pick({ -1, 1 }), 0, 2 / 30)

            self.siner = self.siner + DTMULT

            local rand2 = Utils.pick({ 0, 1 })
            for i = 0, 12 do
                if self.pick2 == "horizontal_slash" then
                    self:spawnBullet("droplet", self.arena_start_x + 73 - i * self.spacing, self.arena_start_y,
                        math.rad(90 + 180 * rand2), 1.5, (1 / (1 + 2 ^ (-20 * math.sin(3 * self.siner + i)))))
                elseif self.pick2 == "vertical_slash" then
                    self:spawnBullet("droplet", self.arena_start_x, self.arena_start_y + 73 - i * self.spacing,
                        math.rad(0 + 180 * rand2), 1.5, (1 / (1 + 2 ^ (-20 * math.sin(3 * self.siner + i)))))
                else
                    self:spawnBullet("droplet", self.arena_start_x, self.arena_start_y,
                        math.rad(0 + 8*i + 180 * rand2), 1.5, (1 / (1 + 2 ^ (-20 * math.sin(3 * self.siner + i)))))
                end
                rand2 = (rand2 + 1) % 2
                self.bulleted = true
            end
        end
        if self.siner2 > self.stretch_length then
            self.stretching = false
            Game.battle.arena:stopShake()
            self.arena2:stopShake()
            self.siner2 = 0
            self.bulleted = false
            self:setArenaShape({ 0, 0 }, { 144, 0 }, { 144, 144 }, { 0, 144 })
            self.arena2:setShape({ { 0, 0 }, { 144, 0 }, { 144, 144 }, { 0, 144 } })
            Game.battle.arena.x, Game.battle.arena.y = self.arena_start_x, self.arena_start_y
            self.arena2.x, self.arena2.y = self.arena_start_x, self.arena_start_y
        end
    end

    super.update(self)
end

function boxcutold:draw()
    if self.stretching then
        self.arena_last_pos_x, self.arena_last_pos_y = Game.battle.arena.x, Game.battle.arena.y
        if self.siner2 < self.stretch_length * 0.5 then
            self.approach = Utils.ease(self.approach, -72, self.siner2 / (self.stretch_length * 0.5), "inCirc")
            self.approach_soul = Utils.ease(self.approach, -36, self.siner2 / (self.stretch_length * 0.5), "outExpo")
        else
            if self.pick2 == "horizontal_slash" or self.pick2 == "vertical_slash" then
                self.approach = Utils.ease(self.approach, 0,(self.siner2 - (self.stretch_length * 0.5)) / (self.stretch_length * 0.5), "inExpo") -- dont need to be nonzero if not moving angle????>
                -- self.approach_soul = Utils.ease(self.approach, 9, (self.siner2-(self.stretch_length*0.5))/(self.stretch_length*0.5), "inExpo")
            else
                self.approach = Utils.ease(self.approach, 36,(self.siner2 - (self.stretch_length * 0.5)) / (self.stretch_length * 0.5), "inExpo")
                self.approach_soul = Utils.ease(self.approach, 36, (self.siner2-(self.stretch_length*0.5))/(self.stretch_length*0.5), "inExpo")

            end
        end
        --    self:setArenaShape({0, 0}, {144, 0}, {0, 144})
        --     self.arena2:setShape({{0, 0}, {144, 0}, {0, 144}})

        if self.pick2 == "horizontal_slash" then
            --   self:setArenaShape({0, self.approach}, {144, self.approach}, {0, 144})
            --   self.arena2:setShape({{0, self.approach}, {144, self.approach}, {0, 144}})
            --      self:setArenaShape({0, 0}, {144, 0}, {144,72}, {0, 72})
            --    self.arena2:setShape({{0, 0}, {144, 0}, {144,72}, {0, 72}})

            self.arena2.y = 36 + self.arena_start_y -self.approach -- the 36 is the middle split. will probably keep?
            Game.battle.arena.y = -36 + self.arena_start_y + self.approach

            if self.siner2 >= self.stretch_length * 0.05 then
                -- need to add something so that it doesnt move if it hits the collider
                if Game.battle.soul.y > self.arena_start_y then
                    Game.battle.soul:move(0, -1, (Game.battle.arena.y - self.arena_last_pos_y)) -- i only need to know about 1 arena, since they move symmetrically
                else
                    Game.battle.soul:move(0, 1, (Game.battle.arena.y - self.arena_last_pos_y))
                end
            end
        elseif self.pick2 == "vertical_slash" then
            --  self:setArenaShape({self.approach, 0}, {144, 0}, {self.approach, 144})
            --   self.arena2:setShape({{self.approach, 0}, {144, 0}, {self.approach, 144}})
            --    self:setArenaShape({0, 0}, {72, 0}, {72,144}, {0, 144})
            --     self.arena2:setShape({{0, 0}, {72, 0}, {72,144}, {0, 144}})
            self.arena2.x = 36 + self.arena_start_x - self.approach
            Game.battle.arena.x = -36 + self.arena_start_x + self.approach
            --  Game.battle.arena:setSize(144*(0.25+1.5*(1/(1+2^(-10*math.sin(math.rad((72/7)*self.siner2/2)))))), 144)
            if self.siner2 >= self.stretch_length * 0.05 then
                if Game.battle.soul.x > self.arena_start_x then
                    Game.battle.soul:move(-1, 0, (Game.battle.arena.x - self.arena_last_pos_x))
                else
                    Game.battle.soul:move(1, 0, (Game.battle.arena.x - self.arena_last_pos_x))
                end
            end
        else
            self.arena2.y = 36 + self.arena_start_y - self.approach -- the 36 is the middle split.
            Game.battle.arena.y = -36 + self.arena_start_y + self.approach
            self.arena2.x = 36 + self.arena_start_x - self.approach
            Game.battle.arena.x = -36 + self.arena_start_x + self.approach
        
       --     Kristal.Console:log(Utils.angle(self.arena_start_x, self.arena_start_y, Game.battle.soul.x, Game.battle.soul.y))
            local check_angle = Utils.angle(self.arena_start_x, self.arena_start_y, Game.battle.soul.x, Game.battle.soul.y)
            if self.siner2 >= self.stretch_length * 0.01 then
                if check_angle > -math.pi/4 and check_angle < 3*math.pi/4 then
                    Game.battle.soul:move(-1, -1, (Game.battle.arena.x - self.arena_last_pos_x))
                else
                    Game.battle.soul:move(1, 1, (Game.battle.arena.x - self.arena_last_pos_x))
                end
            end
        end
    end

    super.draw(self)
end

function boxcutold:onEnd()
    --  Game.battle.arena:remove()
    --    Game.battle.arena = nil

    self.arena2:remove()
    self.arena2 = nil
end

return boxcutold
