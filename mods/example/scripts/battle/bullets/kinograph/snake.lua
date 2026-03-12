local Snake, super = Class(Bullet)

function Snake:init(x, y)
    super.init(self, x, y, "enemies/kinograph/head")
    self.alpha = 0
    self.collider = Hitbox(self, 0, (self.height / 2), self.width , (self.height / 4))
    self.rotation = 0
    self.physics.direction = 0
    self.physics.speed = 9
    self.remove_offscreen = false
    self.timer_turn = 0
    self.distance_check = 120
    self.distance = 0
    self.distance_before = nil
    self.distance_x = 0
    self.distance_y = 0
end

function Snake:onWaveSpawn(wave)
    self:fadeTo(1,0.5)
end

function Snake:update()
    local soul = Game.battle.soul
    local arena = Game.battle.arena
    self.distance = MathUtils.dist(self.x,self.y,arena.x,arena.y)
    if self.distance > self.distance_check then
        self.timer_turn = self.timer_turn + DT
        if self.timer_turn > 0.5 then
            self.timer_turn = 0
            self.physics.direction = self.physics.direction + math.pi
        end
    end
    self.distance_before = MathUtils.dist(self.x,self.y,arena.x,arena.y)
    super.update(self)
end

return Snake
