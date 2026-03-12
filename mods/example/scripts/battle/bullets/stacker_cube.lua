local StackerCube, super = Class(Bullet)

function StackerCube:init(x, y, speed, offset)
    super.init(self, x+ 24 * offset, y, "bullets/stacker_cube")
    self.collider = Hitbox(self, 0, 0, 8, 8)
    self.collidable = false
    self.physics.speed = 0
    self.can_graze = false
    self.dropping = false
    self.set = false
    self.moving = "right"
    self:setScale(3, 3)
    self:setOrigin(0.5, 0.5)
    self.timer_movement = 0
    self.offset = offset
    self.grid_x = self.offset
    self.grid_y = 0
    self.start_x = x
    self.start_y = y
    self.move_direction = 1
    self.movement_speed = speed
    self.state = "MOVING"
    self.timer_movedown = 0
end

function StackerCube:update()
    self.timer_movement = self.timer_movement + DT * self.movement_speed

        self.x = self.start_x + 24 * self.grid_x
        self.y = self.start_y + 24 * self.grid_y

    super.update(self)
end

return StackerCube
