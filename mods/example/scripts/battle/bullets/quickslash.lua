local quickslash, super = Class(Bullet)
-- this is nothing. jsujt replace

function quickslash:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y)
    self:setSprite("bullets/quickslash", 0.5, false, function()
    self:remove() end)
   -- self:play(1,false,self:remove())
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
    self:setScale(2.5, 1)
                self:setOrigin(x,y)
    self.anim_callback = self:remove()
end


return quickslash