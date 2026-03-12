local Water, super = Class(Bullet)

function Water:init(x, y, moving)
    super.init(self, x, y, "bullets/cobblegen/water")

    self.collidable = false
    self.physics.speed = 0
    self.moving = moving
    self.destroy_on_hit = false
    if moving then
        self.placed = false
    else
        self.placed = true
    end
end

function Water:update()
    local arena = Game.battle.arena
    if self.moving then
        self.x = Game.battle.soul.x
        self.y = Game.battle.soul.y
    end
    if self.y > arena:getBottom() - 20 then
        self.moving = false
        if not self.placed then
            self.x = math.floor(self.x / 40) * 40 + 20
        end
        self.placed = true
    end
    super.update(self)
end

return Water
