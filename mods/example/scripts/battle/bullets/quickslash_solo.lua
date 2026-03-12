local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/quickslash_solo")
    self.rotation = dir
    self.physics.match_rotation = true
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.remove_offscreen = false
    self.destroy_on_hit = false
    self.collider = nil
    self.timer = 0
    self.color = {0.8,0,0.8} -- {0.8,0,0}
    self.can_graze = true
    self.layer = BATTLE_LAYERS["below_arena"]

-- should probably kill after a few seconds
end

function SmallBullet:update()
    self.timer = self.timer + DTMULT
        self:setScale(1.3*self.timer,math.max(0,0.8*(10-self.timer)))
        if self.timer > 20 then
            self:remove()
        end


    super.update(self)
end

return SmallBullet