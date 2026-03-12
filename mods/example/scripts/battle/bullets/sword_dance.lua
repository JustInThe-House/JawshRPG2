local sword_dance, super = Class(Bullet)

function sword_dance:init(x, y,r, order,angle,type)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/sword")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.rotation = angle
    self.rotation_start = angle
  --  self.physics.match_rotation = math.rad(-90)
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = 0
    self.inv_timer = 0.25
    self.collider = Hitbox(self, 0, 12, self.width, 6)
    self.remove_offscreen = true
    self.destroy_on_hit = false
    self.can_graze = false
    self.alpha = 0
    self.color = {1,1,1}
    self.charge = false
    self.charge_push = -10
    self.order = order
    self.timer_master = 0
    self.aiming = false
    self.r = r
    self.type = type
end

function sword_dance:update()
    self.alpha = self.alpha + DT
    self.timer_master = self.timer_master + DT
    
    if not self.charge then
        if self.type == 0 then
            self.r = self.r + 0.25*math.cos(2*self.timer_master)
        else
            self.r = self.r - 0.25*math.cos(2*self.timer_master)
        end
        
        self.x = Game.battle.arena.x + self.r*math.cos(self.rotation_start+self.timer_master*2)
        self.y = Game.battle.arena.y + self.r*math.sin(self.rotation_start+self.timer_master*2)
        self.rotation = Utils.angle(self.x, self.y, Game.battle.arena.x, Game.battle.arena.y)
    else
        if self.timer_master < 0.13 then

        elseif self.timer_master < 0.8 then
        else
            self.physics.speed = 130
        end
        -- draw line for angle of attack
    end

    super.update(self)
end

return sword_dance