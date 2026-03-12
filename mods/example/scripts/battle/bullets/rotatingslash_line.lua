local rotatingslash_line, super = Class(Bullet)

function rotatingslash_line:init(x, y, dir,volume, rot)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/rotatingslash_line")
    self.rotation = dir
    self.physics.match_rotation = true
    self.physics.speed = 0
    self.can_graze = false
    self.collider = nil
    self.remove_offscreen = false
    self.destroy_on_hit = false
    self.time_bonus = 0
    self.timer = 0
    self:setScale(0.1, 2.25)
    self.color = {1,1,1}
    self.limit = 0.9
    self.rotstart = self.rotation
    self.rotfinal = 210
  self.approach = 0
  self.volume = volume
  self.rotation_direction = rot
end

function rotatingslash_line:update()
        if self.timer == 0 then
        Assets.playSound("rotatingslash", self.volume)
        end
    self.timer = self.timer + DT
        self:setColor(1-(0.2*self.timer/self.limit),1-self.timer/self.limit,1-(0.2*self.timer/self.limit))
        self.approach = math.rad(Utils.ease(0, self.rotfinal, self.timer/self.limit, "outCubic")+self.timer*60*DTMULT)
        self.rotation = self.rotstart + self.approach * self.rotation_direction
        self:setScale(250*math.min((-1+(1+(self.timer/self.limit))^3),1.5), 2.25-1.5*self.timer/self.limit)


    if self.timer >= self.limit then
        Assets.stopSound("rotatingslash")
        self.wave:spawnBullet("quickslash_solo", self.x, self.y, self.rotation, 0)
        self.wave:spawnBullet("sword_trail", self.x + 400*math.cos(self.rotation), self.y + 400*math.sin(self.rotation), self.rotation+math.rad(180), 150, "box", {0.8,0,0.8})
        self.wave:spawnBulletTo(Game.battle.mask, "line_bullet", self.x + 100*math.cos(self.rotation), self.y + 100*math.sin(self.rotation), self.rotation+math.rad(180),30,1,{1,1,1})
        Assets.playSound("knight_cut1", self.volume)
        Assets.playSound("particle_explosion", self.volume)
        Game.battle.arena:shake(TableUtils.pick({-1,1})*2/self.volume,TableUtils.pick({-1,1})*2/self.volume,0.5/self.volume)
      self:remove()
        
    end
    super.update(self)
end

return rotatingslash_line