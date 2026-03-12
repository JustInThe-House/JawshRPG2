local star_child_trail, super = Class(Bullet)

function star_child_trail:init(x, y, dir, speed)
    super.init(self, x, y, "bullets/star_child_trail")
    self.rotation = dir
    self.physics.speed = speed
    self.collider = nil
    self.physics.match_rotation = true
    self.graphics.remove_shrunk = true

end

function star_child_trail:update()
    self.scale_x = self.scale_x - DT
    self.scale_y = self.scale_y - DT
    super.update(self)
end

return star_child_trail