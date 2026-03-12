---@class MusketTarget : Object
local MusketTarget, super = Class(Object)

function MusketTarget:init(x, y, width, height)
    super.init(self, 0, 0)
    self:setHitbox(x, y, width*2, height*2)
end

return MusketTarget