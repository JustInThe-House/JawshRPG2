local boxcut, super = Class(Wave)
function boxcut:init()
    super.init(self)
    --self:setArenaOffset(-60,42)
    --self:setArenaRotation(78)
    self.arena_base_size = 144
    self.arena_half_size = self.arena_base_size / 2
    self:setArenaSize(self.arena_base_size, self.arena_base_size)
    self.time = 11.8
    self.rate_box = 25
    self.stretching = false
    self.timer_stretching = 0
    self.rate_siner = MathUtils.random(0, 2*math.pi)
    self.cooldown = 45
    self.spacing = 12
    local focus_pick = TableUtils.pick({ "vertical_slash", "horizontal_slash" })
    local off_pick = "vertical_slash"
    if focus_pick == "vertical_slash" then
        off_pick = "horizontal_slash"
    end
    if Game.battle.encounter.difficulty == 0 then
        self.pick_table = { focus_pick, focus_pick, focus_pick, focus_pick, focus_pick, focus_pick, focus_pick, focus_pick}

    elseif Game.battle.encounter.difficulty == 1 then
        self.pick_table = { focus_pick, focus_pick, off_pick, TableUtils.pick({ focus_pick, off_pick}), TableUtils.pick({ focus_pick, off_pick}), TableUtils.pick({ focus_pick, off_pick}), TableUtils.pick({ focus_pick, off_pick}), TableUtils.pick({ focus_pick, off_pick}) }
    elseif Game.battle.encounter.difficulty == 2 then
        self.pick_table = { focus_pick,  TableUtils.pick({ focus_pick, off_pick}), TableUtils.pick({ "forward_slash",
            "back_slash" }), TableUtils.pick({ focus_pick, off_pick}), TableUtils.pick({ focus_pick, off_pick}), TableUtils.pick({ "forward_slash", "back_slash" }), TableUtils.pick({
            "vertical_slash", "horizontal_slash" }), TableUtils.pick({
            "vertical_slash", "horizontal_slash" }) }
            else
              self.pick_table = { focus_pick,  TableUtils.pick({ "vertical_slash", "horizontal_slash" , "forward_slash", "back_slash"}), TableUtils.pick({ "forward_slash",
            "back_slash" }), focus_pick, TableUtils.pick({ focus_pick, off_pick}), TableUtils.pick({ "forward_slash", "back_slash" }), TableUtils.pick({ "vertical_slash", "horizontal_slash" , "forward_slash", "back_slash"}), off_pick}

    end

    self.slash_count = 0
    self.lined = false
    self.bulleted = false
    self.approach = 0
    self.stretch_length = 42
    self.drawing = false

    -- dot and cross products may simplify this  further.

    self.padding = 20

    self.slash_destination_angle = 0
    self.reverse_canvas_order = false


    Game.battle:getEnemyBattler("soyingjawsh").manual_move = true
    self.enemy_movement_x, self.enemy_movement_y = MathUtils.random(10, 25), MathUtils.random(12, 60)

   local img = love.graphics.newImage(Mod.info.path.."/assets/sprites/particles/line.png")
    self.particles = love.graphics.newParticleSystem(img,40)
    self.particles:setColors(0.8, 0, 0.8, 1, 0.8, 0, 0.8, 0)
    self.particles:setParticleLifetime(0.75,2)
    self.particles:setEmissionRate(0)
   -- self.particles:setLinearAcceleration(-50,-50,50,50)
    self.particles:setSpread(math.pi/16)
    self.particles:setRotation(math.pi/2) 

--    self.particles:setSpin(math.pi/4,math.pi/2)
self.particles:setRelativeRotation(true)
 --   self.particles:setRotation(math.pi/4, math.pi/2)
   -- self.particles:setPosition(Game.battle:getEnemyBattler("soyingjawsh").x,Game.battle:getEnemyBattler("soyingjawsh").y)
  --  self.particles:setSizes(0.6,1)
end

function boxcut:onStart()
    Game.battle.arena.sprite.visible = false
    self.drawing = true

    self.og_arena_center_x, self.og_arena_center_y = Game.battle.arena:getCenter()
    self.og_arena_topleft_x, self.og_arena_topleft_y = Game.battle.arena:getLeft() - self.padding,
        Game.battle.arena:getTop() - self.padding
    self.og_arena_topright_x, self.og_arena_topright_y = Game.battle.arena:getRight() + self.padding,
        Game.battle.arena:getTop() - self.padding
    self.og_arena_botleft_x, self.og_arena_botleft_y = Game.battle.arena:getLeft() - self.padding,
        Game.battle.arena:getBottom() + self.padding
    self.og_arena_botright_x, self.og_arena_botright_y = Game.battle.arena:getRight() + self.padding,
        Game.battle.arena:getBottom() + self.padding

    self.arena_sprite = ArenaSpriteSplittable(Game.battle.arena, 0, 0, self.padding)
    Game.battle.arena:addChild(self.arena_sprite)

    -- padding must be added so the arena border draw lines are included in the cut

    --[[self.og_arena_center_x, self.og_arena_center_y = Game.battle.arena:getCenter()
    self.og_arena_topleft_x, self.og_arena_topleft_y = Game.battle.arena:getTopLeft()
    self.og_arena_topright_x, self.og_arena_topright_y = Game.battle.arena:getTopRight()
    self.og_arena_botleft_x, self.og_arena_botleft_y = Game.battle.arena:getBottomLeft()
    self.og_arena_botright_x, self.og_arena_botright_y = Game.battle.arena:getBottomRight()]]
end

function boxcut:update()
    self.rate_box = self.rate_box + DTMULT

    if self.rate_box >= 30 and not self.lined then
        self.lined = true
        if self.slash_count <= 7 then
            self.pick = self.pick_table[self.slash_count + 1]
        else
            self.pick = self.pick_table[1]
        end

        
        self.slash_destination_angle = TableUtils.pick({ -1, 1 }) * MathUtils.random(math.pi / 64, math.pi / 14)
        if self.pick == "vertical_slash" then
            self.slash_destination_angle = self.slash_destination_angle + math.pi / 2
            -- will cause error if testing with a line that is parallel. make sure to set these correct
            if self.slash_destination_angle < math.pi / 2 then
                self.reverse_canvas_order = true
            else
                self.reverse_canvas_order = false
            end
        elseif self.pick == "back_slash" then
            self.slash_destination_angle = self.slash_destination_angle + math.pi / 4
            if self.slash_destination_angle < math.pi / 4 then
                self.reverse_canvas_order = false
            else
                self.reverse_canvas_order = true
            end
        elseif self.pick == "forward_slash" then
            self.slash_destination_angle = self.slash_destination_angle + 3 * math.pi / 4
            if self.slash_destination_angle < 3 * math.pi / 4 then
                self.reverse_canvas_order = false
            else
                self.reverse_canvas_order = false
            end
        else     -- horizontal slash
            self.reverse_canvas_order = false
            if self.slash_destination_angle < 0 then
                self.reverse_canvas_order = true
            else
                self.reverse_canvas_order = false
            end
        end
        --sets the slash angle. changes based on slash tpye. slope could have been used, but angle makes me do it earlier

        self.slash_point_1                                       = { self.og_arena_center_x +
        math.cos(self.slash_destination_angle), self.og_arena_center_y + math.sin(self.slash_destination_angle) }
        self.slash_point_2                                       = { self.og_arena_center_x -
        math.cos(self.slash_destination_angle), self.og_arena_center_y - math.sin(self.slash_destination_angle) }
        -- this creates a small line angled in the direction of the slash. line length increased later

        self.box_intersect_top_x, self.box_intersect_top_y       = Utils.getLineIntersect(self.slash_point_1[1],
                                                                                          self.slash_point_1[2],
                                                                                          self.slash_point_2[1],
                                                                                          self.slash_point_2[2],
                                                                                          self.og_arena_topleft_x,
                                                                                          self.og_arena_topleft_y,
                                                                                          self.og_arena_topright_x,
                                                                                          self.og_arena_topright_y, false,
                                                                                          false)
        self.box_intersect_right_x, self.box_intersect_right_y   = Utils.getLineIntersect(self.slash_point_1[1],
                                                                                          self.slash_point_1[2],
                                                                                          self.slash_point_2[1],
                                                                                          self.slash_point_2[2],
                                                                                          self.og_arena_botright_x,
                                                                                          self.og_arena_botright_y,
                                                                                          self.og_arena_topright_x,
                                                                                          self.og_arena_topright_y, false,
                                                                                          false)
        self.box_intersect_bottom_x, self.box_intersect_bottom_y = Utils.getLineIntersect(self.slash_point_1[1],
                                                                                          self.slash_point_1[2],
                                                                                          self.slash_point_2[1],
                                                                                          self.slash_point_2[2],
                                                                                          self.og_arena_botright_x,
                                                                                          self.og_arena_botright_y,
                                                                                          self.og_arena_botleft_x,
                                                                                          self.og_arena_botleft_y, false,
                                                                                          false)
        self.box_intersect_left_x, self.box_intersect_left_y     = Utils.getLineIntersect(self.slash_point_1[1],
                                                                                          self.slash_point_1[2],
                                                                                          self.slash_point_2[1],
                                                                                          self.slash_point_2[2],
                                                                                          self.og_arena_topleft_x,
                                                                                          self.og_arena_topleft_y,
                                                                                          self.og_arena_botleft_x,
                                                                                          self.og_arena_botleft_y, false,
                                                                                          false)
        -- we now have all possible points where a box side could be slashed. we then choose which 2 sides to slash based on the slash type

        --find the function that copares the lines to decide which direction each point gets slashed.
        -- we jsut need to know the angle to know
        if self.slash_destination_angle == MathUtils.clamp(self.slash_destination_angle, math.pi / 4, 3 * math.pi / 4) then
            self.slash_point_1 = { self.box_intersect_top_x, self.box_intersect_top_y }
            self.slash_point_2 = { self.box_intersect_bottom_x, self.box_intersect_bottom_y }
        else
            self.slash_point_1 = { self.box_intersect_right_x, self.box_intersect_right_y }
            self.slash_point_2 = { self.box_intersect_left_x, self.box_intersect_left_y }
        end
        self.warning_slash = self:spawnBullet("sword_trail", self.og_arena_center_x, self.og_arena_center_y,
                                              self.slash_destination_angle, 0,
                                              "slash", { 0.8, 0, 0.8 })
        Game.battle:getEnemyBattler("soyingjawsh"):slideTo(Game.battle:getEnemyBattler("soyingjawsh").xstart + (self.enemy_movement_x % 40) - 20,
                                       Game.battle:getEnemyBattler("soyingjawsh").ystart + (self.enemy_movement_y % 80) - 40, 0.3, "linear") -- add and after function
                                       Game.battle:getEnemyBattler("soyingjawsh"):setAnimation("slice_prep")
        self.enemy_movement_x, self.enemy_movement_y = self.enemy_movement_x + MathUtils.random(10, 30),
            self.enemy_movement_y + MathUtils.random(12, 60)

            if Game.battle:getEnemyBattler("soyingjawsh").arm.alpha ~= 0 then
                Game.battle:getEnemyBattler("soyingjawsh").arm.alpha = 0
            end
    end


    if self.rate_box >= 60 then
        self:spawnBullet("sword_trail", self.og_arena_center_x + 400 * math.cos(self.slash_destination_angle),
            self.og_arena_center_y + 400 * math.sin(self.slash_destination_angle), self.slash_destination_angle, -300,
            "boxcut", { 0.8, 0, 0.8 })
        Game.stage:addChild(quickslash(self.og_arena_center_x, self.og_arena_center_y, self.slash_destination_angle))

        local width, height = Game.battle.arena.width + self.padding * 2, Game.battle.arena.height + self.padding * 2
     --   Kristal.Console:log(Utils.dump({ self.slash_point_1, self.slash_point_2 }))

        self.arena_sprite:setSplitDirection(self.pick, self.slash_point_1, self.slash_point_2, width, height)
        --  self.arena_sprite:setSplitDirection(self.pick, self.slash_point_1, self.slash_point_2, width-self.padding, height-self.padding)


        -- Kristal.Console:log(Utils.dump({self.og_arena_center_x+math.cos(self.slash_destination_angle)*600, self.og_arena_center_y+math.sin(self.slash_destination_angle)*600, self.og_arena_center_x-math.cos(self.slash_destination_angle)*600, self.og_arena_center_y-math.sin(self.slash_destination_angle)*600}))

        self.arena_sprite:updateSplitPoints(self.og_arena_center_x + math.cos(self.slash_destination_angle) * 600,
            self.og_arena_center_y + math.sin(self.slash_destination_angle) * 600,
            self.og_arena_center_x - math.cos(self.slash_destination_angle) * 600,
            self.og_arena_center_y - math.sin(self.slash_destination_angle) * 600)

        self.arena_sprite:split(self.reverse_canvas_order)
        -- what direction does each existing vertex go? this answers that.
        self.slash_angle = self.slash_destination_angle

        if self.lined then
            self.pick2 = self.pick
            self.lined = false
        end

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
        self.stretching = true
        self.arena_sprite.splitting = true
        self.soul_start_x, self.soul_start_y = Game.battle.soul.x, Game.battle.soul.y
        self.rate_box = self.rate_box - self.cooldown

        Game.battle:getEnemyBattler("soyingjawsh"):setAnimation("slice")
    end

    if self.stretching then
        self.timer_stretching = self.timer_stretching + DTMULT
        if self.timer_stretching >= 3 and not self.bulleted then
            Assets.playSound("boxbreak_wiggly",1,1.1)
            Assets.playSound("air_slash",1,1)
            if  self.pick2 == "forward_slash" or self.pick2 == "back_slash" then
                Assets.playSound("air_slash",1,0.5) 
            end
            self.slash_count = self.slash_count + 1

            Game.battle.arena:shake(TableUtils.pick({ -1, 1 }), TableUtils.pick({ -1, 1 }), 0, 2 / 30)

            self.rate_siner = self.rate_siner + DTMULT

            local rand2 = TableUtils.pick({ 0, 1 })
            for i = 0, 12 do
                if self.pick2 == "horizontal_slash" then
                    self:spawnBullet("droplet", self.og_arena_center_x + 73 - i * self.spacing, self.og_arena_center_y,
                                     math.rad(90 + 180 * rand2), 1.5,
                                     (1 / (1 + 2 ^ (-20 * math.sin(3 * self.rate_siner + i)))))
                elseif self.pick2 == "vertical_slash" then
                    self:spawnBullet("droplet", self.og_arena_center_x, self.og_arena_center_y + 73 - i * self.spacing,
                                     math.rad(0 + 180 * rand2), 1.5,
                                     (1 / (1 + 2 ^ (-20 * math.sin(3 * self.rate_siner + i)))))
                elseif self.pick2 == "forward_slash" then
                    self:spawnBullet("droplet", self.og_arena_center_x, self.og_arena_center_y,
                                     math.rad(0 + 8 * i + 180 * rand2), 1.5,
                                     (1 / (1 + 2 ^ (-20 * math.sin(3 * self.rate_siner + i)))))
                else
                    self:spawnBullet("droplet", self.og_arena_center_x, self.og_arena_center_y,
                                     math.rad(90 + 8 * i + 180 * rand2), 1.5,
                                     (1 / (1 + 2 ^ (-20 * math.sin(3 * self.rate_siner + i)))))
                end
                rand2 = (rand2 + 1) % 2
                self.bulleted = true
                self.particles:setDirection(self.slash_angle)
                
                local speedmin, speedmax = 125, 375
                    self.particles:setSpeed(speedmin,speedmax)
             --   self.particles:setPosition(self.slash_point_2[1],self.slash_point_2[2])
              self.particles:setPosition(Game.battle.arena.x,Game.battle.arena.y)
                self.particles:emit(15)
                    self.particles:setSpeed(-speedmax,-speedmin)
self.particles:emit(15)

            end
        end
        if self.timer_stretching > self.stretch_length then
            self.stretching = false
            self.arena_sprite.splitting = false
            self.arena_sprite:merge(self.pick2)
            Game.battle.arena:stopShake()
            Assets.playSound("locker")
            self.timer_stretching = 0
            self.bulleted = false
        end
        if self.approach == nil then
            self.approach_last_pos = 0
        else
            self.approach_last_pos = self.approach
        end
        self.arena_last_pos_x, self.arena_last_pos_y = Game.battle.arena.x, Game.battle.arena.y
        if self.timer_stretching < self.stretch_length * 0.5 then
            self.approach = Utils.ease(self.approach, -self.arena_half_size,
                                       self.timer_stretching / (self.stretch_length * 0.5),
                                       "inQuad") --"inQuad" inCirc linaer
        else
            self.approach = Utils.ease(self.approach, 0,
                                       (self.timer_stretching - (self.stretch_length * 0.5)) /
                                       (self.stretch_length * 0.5),
                                       "inQuint") -- inExpo
        end

        -- update this so that the set angle is used. makes things simpler, and may make things work. also add tween functions
        if self.pick2 == "horizontal_slash" then
            self:setArenaShape({ 0, 0 + self.approach }, { self.arena_base_size, 0 + self.approach },
                               { self.arena_base_size, self.arena_half_size +
                               self.arena_half_size * math.sin(self.slash_angle) + self.approach },
                               { self.arena_base_size, self.arena_half_size +
                               self.arena_half_size * math.sin(self.slash_angle) - self.approach },
                               { self.arena_base_size, self.arena_base_size - self.approach },
                               { 0, self.arena_base_size - self.approach },
                               { 0, self.arena_half_size - self.arena_half_size * math.sin(self.slash_angle) -
                               self.approach },
                               { 0, self.arena_half_size - self.arena_half_size * math.sin(self.slash_angle) +
                               self.approach })
            if Game.battle.soul.y > self.og_arena_center_y then
                Game.battle.soul.y = Game.battle.soul.y - (self.approach - self.approach_last_pos)
            else
                Game.battle.soul.y = Game.battle.soul.y + (self.approach - self.approach_last_pos)
            end
            self.arena_sprite.canvas_1_offset = { 0, -2 * self.approach }
            self.arena_sprite.canvas_2_offset = { 0, 0 }
        elseif self.pick2 == "vertical_slash" then
            self:setArenaShape({ 0 + self.approach, 0 },
                               { self.arena_half_size - self.arena_half_size * math.cos(self.slash_angle) + self
                               .approach, 0 },
                               { self.arena_half_size - self.arena_half_size * math.cos(self.slash_angle) - self
                               .approach, 0 },
                               { self.arena_base_size - self.approach, 0 },
                               { self.arena_base_size - self.approach, self.arena_base_size },
                               { self.arena_half_size + self.arena_half_size * math.cos(self.slash_angle) - self
                               .approach, self.arena_base_size },
                               { self.arena_half_size + self.arena_half_size * math.cos(self.slash_angle) + self
                               .approach, self.arena_base_size }, { 0 + self.approach, self.arena_base_size })

            if Game.battle.soul.x > self.og_arena_center_x then
                Game.battle.soul.x = Game.battle.soul.x - (self.approach - self.approach_last_pos)
            else
                Game.battle.soul.x = Game.battle.soul.x + (self.approach - self.approach_last_pos)
            end
            self.arena_sprite.canvas_1_offset = { 0, 0 }
            self.arena_sprite.canvas_2_offset = { -2 * self.approach, 0 }
        elseif self.pick2 == "forward_slash" then
            --  Kristal.Console:log(Utils.dump(self.slash_angle))
            --  Kristal.Console:log(Utils.dump({self.slash_point_1[1], self.slash_point_1[2], self.slash_point_2[1], self.slash_point_2[2]}))

            if self.slash_angle < 3 * math.pi / 4 then
                self:setArenaShape({ 0 + self.approach, 0 + self.approach },
                                   { self.arena_half_size - self.arena_half_size * math.sin(self.slash_angle) +
                                   self.approach, 0 + self.approach },
                                   { self.arena_half_size - self.arena_half_size * math.sin(self.slash_angle) -
                                   self.approach, 0 - self.approach },
                                   { self.arena_base_size - self.approach, 0 - self.approach },
                                   { self.arena_base_size - self.approach, -self.arena_base_size - self.approach },
                                   { self.arena_half_size + self.arena_half_size * math.sin(self.slash_angle) -
                                   self.approach, -self.arena_base_size - self.approach },
                                   { self.arena_half_size + self.arena_half_size * math.sin(self.slash_angle) +
                                   self.approach, -self.arena_base_size + self.approach },
                                   { 0 + self.approach, -self.arena_base_size + self.approach })
            else
                self:setArenaShape({ 0 - self.approach, 0 - self.approach },
                                   { self.arena_base_size - self.approach, 0 - self.approach },
                                   { self.arena_base_size - self.approach, -self.arena_half_size +
                                   self.arena_half_size * math.cos(self.slash_angle) - self.approach },
                                   { self.arena_base_size + self.approach, -self.arena_half_size +
                                   self.arena_half_size * math.cos(self.slash_angle) + self.approach },
                                   { self.arena_base_size + self.approach, -self.arena_base_size + self.approach },
                                   { 0 + self.approach, -self.arena_base_size + self.approach },
                                   { 0 + self.approach, -self.arena_half_size -
                                   self.arena_half_size * math.cos(self.slash_angle) + self.approach },
                                   { 0 - self.approach, -self.arena_half_size -
                                   self.arena_half_size * math.cos(self.slash_angle) - self.approach })
            end

            local check_angle = MathUtils.angle(self.og_arena_center_x, self.og_arena_center_y, Game.battle.soul.x,
                                            Game.battle.soul.y)
            if check_angle == MathUtils.clamp(check_angle, -math.pi / 4, 3 * math.pi / 4) then
                Game.battle.soul.x = Game.battle.soul.x - (self.approach - self.approach_last_pos)
                Game.battle.soul.y = Game.battle.soul.y - (self.approach - self.approach_last_pos)
            else
                Game.battle.soul.x = Game.battle.soul.x + (self.approach - self.approach_last_pos)
                Game.battle.soul.y = Game.battle.soul.y + (self.approach - self.approach_last_pos)
            end
            self.arena_sprite.canvas_1_offset = { 0, 0 }
            self.arena_sprite.canvas_2_offset = { -2 * self.approach, -2 * self.approach }
        else -- backslash
            if self.slash_angle < math.pi / 4 then
                self:setArenaShape({ 0 + self.approach, 0 - self.approach },
                                   { self.arena_base_size + self.approach, 0 - self.approach },
                                   { self.arena_base_size + self.approach, -self.arena_half_size +
                                   self.arena_half_size * math.sin(self.slash_angle) - self.approach },
                                   { self.arena_base_size - self.approach, -self.arena_half_size +
                                   self.arena_half_size * math.sin(self.slash_angle) + self.approach },
                                   { self.arena_base_size - self.approach, -self.arena_base_size + self.approach },
                                   { 0 - self.approach, -self.arena_base_size + self.approach },
                                   { 0 - self.approach, -self.arena_half_size -
                                   self.arena_half_size * math.sin(self.slash_angle) + self.approach },
                                   { 0 + self.approach, -self.arena_half_size -
                                   self.arena_half_size * math.sin(self.slash_angle) - self.approach })
            else
                self:setArenaShape({ 0 + self.approach, 0 - self.approach },
                                   { self.arena_half_size + self.arena_half_size * math.cos(self.slash_angle) +
                                   self.approach, 0 - self.approach },
                                   { self.arena_half_size + self.arena_half_size * math.cos(self.slash_angle) -
                                   self.approach, 0 + self.approach },
                                   { self.arena_base_size - self.approach, 0 + self.approach },
                                   { self.arena_base_size - self.approach, -self.arena_base_size + self.approach },
                                   { self.arena_half_size - self.arena_half_size * math.cos(self.slash_angle) -
                                   self.approach, -self.arena_base_size + self.approach },
                                   { self.arena_half_size - self.arena_half_size * math.cos(self.slash_angle) +
                                   self.approach, -self.arena_base_size - self.approach },
                                   { 0 + self.approach, -self.arena_base_size - self.approach })
            end
            local check_angle = MathUtils.angle(self.og_arena_center_x, self.og_arena_center_y, Game.battle.soul.x,
                                            Game.battle.soul.y)
            if check_angle == MathUtils.clamp(check_angle, -3 * math.pi / 4, math.pi / 4) then
                Game.battle.soul.x = Game.battle.soul.x - (self.approach - self.approach_last_pos)
                Game.battle.soul.y = Game.battle.soul.y + (self.approach - self.approach_last_pos)
            else
                Game.battle.soul.x = Game.battle.soul.x + (self.approach - self.approach_last_pos)
                Game.battle.soul.y = Game.battle.soul.y - (self.approach - self.approach_last_pos)
            end
            self.arena_sprite.canvas_1_offset = { 0, -2 * self.approach }
            self.arena_sprite.canvas_2_offset = { -2 * self.approach, 0 }
        end
        if not self.stretching then
            self:setArenaShape({ 0, 0 }, { self.arena_base_size, 0 }, { self.arena_base_size, self.arena_base_size },
                               { 0, self.arena_base_size })
        end
    end






    --self.particles:setPosition(Game.battle:getEnemyBattler("soyingjawsh").x,Game.battle:getEnemyBattler("soyingjawsh").y)
    self.particles:update(DT)

    super.update(self)
end

function boxcut:draw()
if self.particles ~= nil then
    love.graphics.draw(self.particles, 0, 0)
end

    super.draw(self)
end

function boxcut:onEnd()
    Game.battle:getEnemyBattler("soyingjawsh"):slideTo(Game.battle:getEnemyBattler("soyingjawsh").xstart, Game.battle:getEnemyBattler("soyingjawsh").ystart, 0.5, "linear",
        function()
            Game.battle:getEnemyBattler("soyingjawsh").siner = 0
            Game.battle:getEnemyBattler("soyingjawsh").manual_move = false
            Game.battle:getEnemyBattler("soyingjawsh"):resetSprite()
            Game.battle:getEnemyBattler("soyingjawsh").arm.alpha = 1
          --  Kristal.Console:log(Utils.dump({ self.particles:getPosition() }))
        end)
end

return boxcut
