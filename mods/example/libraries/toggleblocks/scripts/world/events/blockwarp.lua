--- A Block Warp! When the box is "destroyed" by a toggle block it goes back to here.
--- `BlockWarp` is an [`Event`](lua://Event.init) - naming an object `blockwarp` on an `objects` layer in a map creates this object. \
--- See this object's Fields for the configurable properties on this object.
--- 
---@class BlockWarp : Event
---
---@field custom_sprite     string    *[Property `sprite`]* An optional custom off sprite the block uses
---@field linked_block      integer   *[Property `block`]* The ID of the block linked to this spawn
---
---@overload fun(...) : BlockWarp
local BlockWarp, super = Class(Event)

function BlockWarp:init(data)
    super.init(self, data)

    local properties = data.properties or {}

    self.custom_sprite = properties["sprite"] or "world/events/blockwarp"
    self.linked_block = properties["block"]

    self:setSprite(self.custom_sprite)
end

---@param linked_block Object|Event
function BlockWarp:warpBlock(linked_block)
    linked_block:setPosition(self.x, self.y)
    self:onWarpBlock()
end

function BlockWarp:onWarpBlock()
end

return BlockWarp