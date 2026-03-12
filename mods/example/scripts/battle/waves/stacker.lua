local StackerGame, super = Class(Wave)

function StackerGame:init()
    super.init(self)
    self:setArenaSize(176, 242)
    self.time = 180
    self.create_stack = false
    self.stack_number = 0
    self.stack_offset = 0
    self.speed_start = 5 / 6
    self.speed_increase = 4 / 18
    self.spawn_soul = false -- no soul spawned
    -- self.has_arena = false -- no arena
    self.gameover = false
    self.max_stack = 0
    self.max_stack_before = 0
    self.controller_moving = "right"
    self.controller_direction = 1
    self.controller_grid_x = 0
    self.pause_before_drop = 0.06
    self.timer_movedown = 0
    self.ready = false
end

function StackerGame:onStart()
    self:setHitbox(Game.battle.arena:getLeft() - 10, Game.battle.arena:getBottom() - 9, Game.battle.arena:getRight() + 10,
                   20)
    self.center_x, self.center_y = Game.battle.arena:getCenter()
    self.top_y = Game.battle.arena:getTop()
    self.timer:after(0.5, function()
        self:spawnBullet("stacker_cube", self.center_x, self.top_y + 13,
                         self.speed_start + self.stack_number * self.speed_increase, 0)
        self:spawnBullet("stacker_cube", self.center_x, self.top_y + 13,
                         self.speed_start + self.stack_number * self.speed_increase, 1)
        self:spawnBullet("stacker_cube", self.center_x, self.top_y + 13,
                         self.speed_start + self.stack_number * self.speed_increase, -1)
                         self.ready = true
    end)
end

function StackerGame:update()
    self.moving_stack = TableUtils.filter(self.bullets, function(e) return e.state == "MOVING" end)
    self.dropping_stack = TableUtils.filter(self.bullets, function(e) return e.state == "DROPPING" end)
    self.set_stack = TableUtils.filter(self.bullets, function(e) return e.state == "SET" end)
    --   Kristal.Console:log(Utils.dump(self.moving_stack))

    if Input.pressed("confirm") and not self.create_stack and self.ready then
        Input.clear("confirm")
        self.create_stack = true
        for _, stack in ipairs(self.moving_stack) do
            stack.state = "DROPPING"
        end
        self.timer_restack = self.timer:after(0.7, function()
            self.stack_number = self.stack_number + 1
            for _, stack in ipairs(self.set_stack) do
                if stack.grid_y == 0 then
                    Game.battle:getEnemyBattler("stacker_machine").money = 300
                    Game.battle:getEnemyBattler("stacker_machine"):flash()
                    Game.battle:getEnemyBattler("stacker_machine").color = {1,1,0}
                    Assets.playSound("sparkle_gem")
                    Game.battle:endWaves()
                    self.gameover = true
                end
            end

            if self.max_stack == self.max_stack_before then
                Assets.playSound("error")
                Game.battle:endWaves()
                self.gameover = true
            else
                self.max_stack_before = self.max_stack
            end

            if not self.gameover then
                if self.stack_number <= 1 then
        self:spawnBullet("stacker_cube", self.center_x, self.top_y + 13,
                         self.speed_start + self.stack_number * self.speed_increase, 0)
        self:spawnBullet("stacker_cube", self.center_x, self.top_y + 13,
                         self.speed_start + self.stack_number * self.speed_increase, 1)
        self:spawnBullet("stacker_cube", self.center_x, self.top_y + 13,
                         self.speed_start + self.stack_number * self.speed_increase, -1)
                elseif self.stack_number <= 6 then
        self:spawnBullet("stacker_cube", self.center_x, self.top_y + 13,
                         self.speed_start + self.stack_number * self.speed_increase, 0)
        self:spawnBullet("stacker_cube", self.center_x, self.top_y + 13,
                         self.speed_start + self.stack_number * self.speed_increase, 1)
                else
                    self:spawnBullet("stacker_cube", self.center_x, self.top_y + 13,
                                     self.speed_start + self.stack_number * self.speed_increase, 0)
                end
                self.create_stack = false
            end
        end)
    end



    for _, stack in ipairs(self.dropping_stack) do
        for _, stack_check in ipairs(self.set_stack) do
            if stack.grid_x == stack_check.grid_x and stack.grid_y == stack_check.grid_y - 1 then
                stack.state = "SET"
            end
        end
        if stack.state == "DROPPING" and stack.timer_movement >= self.pause_before_drop then
            if stack.grid_y <= 8 then
                stack.timer_movedown = stack.timer_movedown + DT

                if stack.timer_movedown >= 0.016 then -- adding this makes it more consistent. update in stackercube too. ow fps is doubled
                stack.grid_y = stack.grid_y + 1
                stack.timer_movedown = 0
                end
            else
                stack.state = "SET"
            end
        end
    end


    for _, stack in ipairs(self.moving_stack) do
        if stack.timer_movement >= 0.1 then
            stack.timer_movement = 0
            if stack.offset == 0 then
                if #self.moving_stack == 3 then
                    if stack.grid_x > 1 then
                        self.controller_moving = "left"
                        self.controller_direction = -1
                    elseif stack.grid_x < -1 then
                        self.controller_moving = "right"
                        self.controller_direction = 1
                    end
                elseif #self.moving_stack == 2 then
                    if stack.grid_x > 1 then
                        self.controller_moving = "left"
                        self.controller_direction = -1
                    elseif stack.grid_x < -2 then
                        self.controller_moving = "right"
                        self.controller_direction = 1
                    end
                elseif #self.moving_stack == 1 then
                    if stack.grid_x > 2 then
                        self.controller_moving = "left"
                        self.controller_direction = -1
                    elseif stack.grid_x < -2 then
                        self.controller_moving = "right"
                        self.controller_direction = 1
                    end
                end
                stack.grid_x = stack.grid_x + self.controller_direction
                self.controller_grid_x = stack.grid_x
            end
            --Kristal.Console:log(Utils.dump({ self.controller_grid_x }))
            stack.grid_x = self.controller_grid_x + stack.offset
        end
    end
    for _, stack in ipairs(self.set_stack) do
        self.max_stack = math.max(self.max_stack, 10 - stack.grid_y)
    end

    super.update(self)
end

return StackerGame
