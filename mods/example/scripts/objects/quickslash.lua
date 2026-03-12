local quickslash, super = Class(Sprite)

function quickslash:init(x, y, dir)
    -- Last argument = sprite path
    super.init(self, "bullets/quickslash", x, y)
    
    self:play(0.1, false, function()
    self:remove() end) -- i needed the function() for it to work... smh
    self.rotation = dir
    self.physics.match_rotation = true
    self.layer = BATTLE_LAYERS["below_ui"]
    self.remove_offscreen = false
    self.color = {0.8,0,0.8} -- {0.8,0,0}
    self.can_graze = true
    self:setScale(3, 1)
    self:setOrigin(0.5,0.5)
end


return quickslash