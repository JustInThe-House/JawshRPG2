local object, super = Class(Sprite, "slash_long")

function object:init(x, y)
    super.init(self, "attacks/slash_long/slash_long", x, y)
    self:setAnimation("attacks/slash_long/slash_long")

end

return object
