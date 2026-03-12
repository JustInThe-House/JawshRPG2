-- includes hooks for soul speed, focus mode
---@class Soul : Object
---@field iframes         number    factor for how much % iframes you get
---@field tp_take         number    timer for removing tp for a soul ability
---@field soul_focus_speed number   movement speed when
local Soul, super = HookSystem.hookScript(Soul)

function Soul:init(x, y, color)
    super.super.init(self, x, y)

    if color then
        self:setColor(color)
    else
        self:setColor(1, 0.5, 0)
    end

    self.layer             = BATTLE_LAYERS["soul"]

    --    self.speed = 4
    self.graze_tp_factor   = 1
    self.graze_time_factor = 1
    self.graze_size_factor = 1
    self.iframes           = 0
    self.tp_take           = 0
    local speed            = 0

    self.soul_focus_speed  = 0
    self.soul_focus_tp     = 0
    for _, party in ipairs(Game.party) do
        self.graze_tp_factor = MathUtils.clamp(self.graze_tp_factor + party:getStat("graze_tp"), 0, 3)
        self.graze_time_factor = MathUtils.clamp(self.graze_time_factor + party:getStat("graze_time"), 0, 3)
        self.graze_size_factor = MathUtils.clamp(
            self.graze_size_factor + party:getStat("graze_size") +
            Game.battle.turn_count * party:getStat("graze_size_turn"),
            0, 3)
        speed = speed + party:getStat("soul_speed") + party:getStat("temp_soul_speed")
        self.iframes = self.iframes + party:getStat("iframes")

        self.soul_focus_speed = MathUtils.clamp(self.soul_focus_speed + party:getStat("soul_focus_speed"), 0, 10)
        self.soul_focus_tp = self.soul_focus_tp + party:getStat("soul_focus_tp")
    end



    self.speed = 4 * (1 + speed)



    self.sprite = Sprite("player/heart_dodge")
    self.sprite:setScale(0.25, 0.25)
    self.sprite:setOrigin(0.5, 0.5)
    self.sprite.inherit_color = true
    self:addChild(self.sprite)

    self.graze_sprite = GrazeSprite()
    self.graze_sprite:setOrigin(0.5, 0.5)
    self.graze_sprite.inherit_color = true
    self.graze_sprite.graze_scale = self.graze_size_factor
    self:addChild(self.graze_sprite)

    self.width = self.sprite.width
    self.height = self.sprite.height

    self.debug_rect = { -8, -8, 16, 16 }

    self.collider = CircleCollider(self, 0, 0, 8)

    self.graze_collider = CircleCollider(self, 0, 0, 25 * self.graze_size_factor)

    self.original_x = x
    self.original_y = y
    self.target_x = x
    self.target_y = y
    self.timer = 0
    self.transitioning = false

    self.inv_timer = 0
    self.inv_flash_timer = 0

    -- 1px movement increments
    self.partial_x = (self.x % 1)
    self.partial_y = (self.y % 1)

    self.last_collided_x = false
    self.last_collided_y = false

    self.x = math.floor(self.x)
    self.y = math.floor(self.y)

    self.moving_x = 0
    self.moving_y = 0

    self.noclip = false
    self.slope_correction = true

    self.transition_destroy = false

    self.shard_x_table = { -2, 0, 2, 8, 10, 12 }
    self.shard_y_table = { 0, 3, 6 }

    self.can_move = true
    self.allow_focus = true

    self.target_alpha = 1
end

function Soul:doMovement()
    local speed = self.speed

    -- Do speed calculations here if required.

    --focus mode
    if self.allow_focus then
        if Input.down("cancel") then
            if self.soul_focus_tp > 0 and Game:getTension() > self.soul_focus_tp then
                self.tp_take = self.tp_take + self.soul_focus_tp
                if self.tp_take >= 4 then
                    self.tp_take = 0
                    Game:removeTension(self.soul_focus_tp)
                end
                speed = speed + self.soul_focus_speed
            end
            speed = (speed / 2)
        end
    end

    local move_x, move_y = 0, 0

    -- Keyboard input:
    if Input.down("left") then move_x = move_x - 1 end
    if Input.down("right") then move_x = move_x + 1 end
    if Input.down("up") then move_y = move_y - 1 end
    if Input.down("down") then move_y = move_y + 1 end

    self.moving_x = move_x
    self.moving_y = move_y

    if move_x ~= 0 or move_y ~= 0 then
        if not self:move(move_x, move_y, speed * DTMULT) then
            self.moving_x = 0
            self.moving_y = 0
        end
    end
end

function Soul:update()
    if self.transitioning then
        if self.timer >= 7 then
            Input.clear("cancel")
            self.timer = 0
            if self.transition_destroy then
                Game.battle:addChild(HeartBurst(self.target_x, self.target_y, { Game:getSoulColor() }))
                self:remove()
            else
                self.transitioning = false
                self:setExactPosition(self.target_x, self.target_y)
            end
        else
            self:setExactPosition(
                MathUtils.lerp(self.original_x, self.target_x, MathUtils.clamp(self.timer / 7, 0, 1)),
                MathUtils.lerp(self.original_y, self.target_y, MathUtils.clamp(self.timer / 7, 0, 1))
            )
            self.alpha = MathUtils.lerp(0, self.target_alpha or 1, MathUtils.clamp(self.timer / 5, 0, 1))  --used to be /3
            self.sprite:setColor(1,1,1,self.alpha)-- setColor(self.color[1], self.color[2], self.color[3], self.alpha) somehow this causes it to turn red initially
            self.timer = self.timer + (1 * DTMULT)
          --  Kristal.Console:log(Utils.dump(self.color))
        end
        return
    end

    -- Input movement
    if self.can_move then
        self:doMovement()
    end

    -- Bullet collision !!! Yay

    if self.inv_timer > 0 then
        self.inv_timer = MathUtils.approach(self.inv_timer, 0, DT / (1 + self.iframes))
        --Kristal.Console:log(Utils.dump(self.inv_timer))
    end

    local collided_bullets = {}
    Object.startCache()
    for _, bullet in ipairs(Game.stage:getObjects(Bullet)) do
        if bullet:collidesWith(self.collider) then
            -- Store collided bullets to a table before calling onCollide
            -- to avoid issues with cacheing inside onCollide
            table.insert(collided_bullets, bullet)
        end
        if self.inv_timer == 0 then
            if bullet:canGraze() and bullet:collidesWith(self.graze_collider) then
                local old_graze = bullet.grazed
                if bullet.grazed then
                    Game:giveTension(bullet:getGrazeTension() * DT * self.graze_tp_factor)
                    if Game.battle.wave_timer < Game.battle.wave_length - (1 / 3) then
                        Game.battle.wave_timer = Game.battle.wave_timer +
                            (bullet.time_bonus * (DT / 30) * self.graze_time_factor)
                    end
                    if self.graze_sprite.timer < 0.1 then
                        self.graze_sprite.timer = 0.1
                    end
                    bullet:onGraze(false)
                else
                    Assets.playSound("graze")
                    Game:giveTension(bullet:getGrazeTension() * self.graze_tp_factor)
                    if Game.battle.wave_timer < Game.battle.wave_length - (1 / 3) then
                        Game.battle.wave_timer = Game.battle.wave_timer +
                            ((bullet.time_bonus / 30) * self.graze_time_factor)
                    end
                    self.graze_sprite.timer = 1 / 3
                    bullet.grazed = true
                    bullet:onGraze(true)
                end
                self:onGraze(bullet, old_graze)
            end
        end
    end
    Object.endCache()
    for _, bullet in ipairs(collided_bullets) do
        self:onCollide(bullet)
    end

    if self.inv_timer > 0 then
        self.inv_flash_timer = self.inv_flash_timer + DT
        local amt = math.floor(self.inv_flash_timer / (4 / 30))
        if (amt % 2) == 1 then
            self.sprite:setColor(0.5, 0.5, 0.5)
        else
            self.sprite:setColor(1, 1, 1)
        end
    else
        self.inv_flash_timer = 0
        self.sprite:setColor(1, 1, 1)
    end

    super.super.update(self)
end

return Soul
