local Bubble_Child, super = Class(Bullet)

function Bubble_Child:init(x, y, dir, speed)
    super.init(self, x, y, "bullets/minecraft_bubble/bubble")

    self.collider = CircleCollider(self, self.width / 2, self.height / 2, 2)
    self.rotation = 0 
    self.physics.direction = dir
    self.physics.speed = speed
    self:setScale(1, 1)
end

return Bubble_Child