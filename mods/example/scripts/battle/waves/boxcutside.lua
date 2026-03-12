local boxcutside, super = Class(Wave)

function boxcutside:init()
    super.init(self)
    
    self.arena_base_size = 148
    self:setArenaSize(self.arena_base_size, self.arena_base_size)

    self.pick = Utils.pick({ 0, 1, 2, 3 })
    self.time = 13
    self.siner = Utils.random(0, 6)
    self.rand = Utils.pick({ 0, 1 })

    self.lined = false
    self.slashed = false
    self.approach = 1
    self.bulleted = false
    self.timer_droplet = 1
    self.cooldown = 0.95
    
end

function boxcutside:onStart()
    self.arena_height_start, self.arena_width_start = Game.battle.arena.height, Game.battle.arena.width
    self.arena_x_start, self.arena_y_start = Game.battle.arena.x, Game.battle.arena.y
            if self.pick == 0 then
            self:spawnBullet("sword_trail", Game.battle.arena.x, Game.battle.arena.y - 50, 0, 0, "slash", { 0.8, 0, 0.8 })
        elseif self.pick == 1 then
            self:spawnBullet("sword_trail", Game.battle.arena.x, Game.battle.arena.y + 50, 0, 0, "slash", { 0.8, 0, 0.8 })
        elseif self.pick == 2 then
            self:spawnBullet("sword_trail", Game.battle.arena.x - 60, Game.battle.arena.y, math.rad(90), 0, "slash",
                { 0.8, 0, 0.8 })
        else
            self:spawnBullet("sword_trail", Game.battle.arena.x + 60, Game.battle.arena.y, math.rad(90), 0, "slash",
                { 0.8, 0, 0.8 })
        end
end

function boxcutside:getRemainingTime()
    return self.time - Game.battle.wave_timer
end

function boxcutside:update()
    if Game.battle.wave_timer >= 1 and Game.battle.wave_timer < 1.3 then
        if not self.slashed then
            local sound = Assets.newSound("air_slash")
            sound:setPitch(1)
            sound:play()
            self.slashed = true
                        Game.battle.arena:shake(Utils.pick({ -0.5, 0.5 }), Utils.pick({ -0.5, 0.5 }), 0, 2 / 30)

        end
        if self.approach == nil then
            self.approach_last_pos = 0
        else
            self.approach_last_pos = self.approach
        end

        self.approach = Utils.ease(self.approach, self.arena_base_size/2, (Game.battle.wave_timer - 1) / (1.3 - 1), "inQuad")

        if self.pick == 0 then
            self:setArenaShape({ 0, 0 }, { self.arena_base_size, 0 }, { self.arena_base_size, self.arena_base_size + self.approach }, { 0, self.arena_base_size + self.approach })
            Game.battle.arena.y = self.arena_y_start + self.approach / 2
            Game.battle.soul.y = Game.battle.soul.y + (self.approach - self.approach_last_pos)
        elseif self.pick == 1 then
            self:setArenaShape({ 0, 0 }, { self.arena_base_size, 0 }, { self.arena_base_size, self.arena_base_size + self.approach }, { 0, self.arena_base_size + self.approach })
            Game.battle.arena.y = self.arena_y_start - self.approach / 2
            Game.battle.soul.y = Game.battle.soul.y - (self.approach - self.approach_last_pos)
        elseif self.pick == 2 then
            self:setArenaShape({ 0, 0 }, { self.arena_base_size + self.approach, 0 }, { self.arena_base_size + self.approach, self.arena_base_size }, { 0, self.arena_base_size })
            Game.battle.soul.x = Game.battle.soul.x + (self.approach - self.approach_last_pos)

            Game.battle.arena.x = self.arena_x_start + self.approach / 2
        else
            self:setArenaShape({ 0, 0 }, { self.arena_base_size + self.approach, 0 }, { self.arena_base_size + self.approach, self.arena_base_size }, { 0, self.arena_base_size })
            Game.battle.soul.x = Game.battle.soul.x - (self.approach - self.approach_last_pos)

            Game.battle.arena.x = self.arena_x_start - self.approach / 2
        end
    elseif Game.battle.wave_timer >= 2.2 then
        self.timer_droplet = self.timer_droplet + DT
        self.siner = self.siner + DTMULT

        if self.timer_droplet > self.cooldown then
            self.rand = Utils.pick({ 5, 6 })
            if self.rand == 5 then
                self.spacing = 27
            else
                self.spacing = 23
            end


            for i = 0, self.rand do
                if self.pick == 0 then
                    self:spawnBullet("droplet", Game.battle.arena:getRight() - 5 - i * self.spacing,
                        Game.battle.arena:getTop() - 10,
                        math.rad(90), 1.5, ((1 / (2 ^ (-2*math.sin(self.siner + i))))-0.25)/3.75)
                elseif self.pick == 1 then
                    self:spawnBullet("droplet", Game.battle.arena:getRight() - 5 - i * self.spacing,
                        Game.battle.arena:getBottom() + 10,
                        math.rad(270), 1.5, ((1 / (2 ^ (-2*math.sin(self.siner + i))))-0.25)/3.75)
                elseif self.pick == 2 then
                    self:spawnBullet("droplet", Game.battle.arena:getLeft() - 10,
                        Game.battle.arena:getBottom() - 5 - i * self.spacing,
                        math.rad(0), 1.5, ((1 / (2 ^ (-2*math.sin(self.siner + i))))-0.25)/3.75)
                else
                    self:spawnBullet("droplet", Game.battle.arena:getRight() + 10,
                        Game.battle.arena:getBottom() - 5 - i * self.spacing,
                        math.rad(180), 1.5, ((1 / (2 ^ (-2*math.sin(self.siner + i))))-0.25)/3.75)
                end
                --math.abs(math.sin(self.siner + i))^5)
                --((1 / (2 ^ (-math.sin(self.siner + i))))-0.5)/1.5)
            end
            self.timer_droplet = self.timer_droplet - self.cooldown
        end





        if self.pick == 0 then
            Game.battle.soul.y = Game.battle.soul.y - 3.5 * DTMULT
        elseif self.pick == 1 then
            Game.battle.soul.y = Game.battle.soul.y + 3.5 * DTMULT
        elseif self.pick == 2 then
            Game.battle.soul.x = Game.battle.soul.x - 3.5 * DTMULT
        else
            Game.battle.soul.x = Game.battle.soul.x + 3.5 * DTMULT
        end
    end
    super.update(self)
end

return boxcutside
