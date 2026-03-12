--- A Player Warp! When the player is "destroyed" by a toggle block it goes back to here.
--- `PlayerWarp` is an [`Event`](lua://Event.init) - naming an object `playerwarp` on an `objects` layer in a map creates this object. \
--- See this object's Fields for the configurable properties on this object.
--- 
---@class PlayerWarp : Event
---
---@field custom_sprite     string    *[Property `sprite`]* An optional custom off sprite the block uses
---
---@overload fun(...) : BlockWarp
local PlayerWarp, super = Class(Event)

function PlayerWarp:init(data)
    super.init(self, data)

    local properties = data.properties or {}

    self.custom_sprite = properties["sprite"] or "world/events/playerwarp"

    self:setSprite(self.custom_sprite)
end

function PlayerWarp:warpPlayer()
    Game.world.player:setPosition(self.x + self.width / 2, self.y + self.height / 2)
    self:onWarpPlayer()
end

function PlayerWarp:onWarpPlayer()
end

return PlayerWarp