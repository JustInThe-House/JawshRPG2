--- A Toggleable Block! Has collision when on and doesn't when off!
--- `ToggleBlock` is an [`Event`](lua://Event.init) - naming an object `toggleblock` on an `objects` layer in a map creates this object. \
--- Creating a rectangle will create a wall of blocks :)
--- See this object's Fields for the configurable properties on this object.
--- 
---@class ToggleBlock : Event
---
---@field block_color       string      *[Property `color`]* The color of the block, changes the sprite to the default 6 sprites, defaults to red
---@field on_sprite         string      *[Property `onsprite`]* An optional custom on the block should use
---@field off_sprite        string      *[Property `offsprite`]* An optional custom off sprite the block uses
---
---@field flag              string[]    *[Property `flag`]* The name of the flag(s) to check for whether targets should be active, if any of them are true the blocks will active - if `!` is at the start of the flag, the check will be [`inverted`]
---@field inverted          boolean     *[Property `inverted`]* Whether the flagcheck is inverted such that if `flag` is `flag_value`, the blocks are inactive, and active otherwise
---
---@field block_data        table       The data for the blocks
---
---@overload fun(...) : ToggleBlock
local ToggleBlock, super = Class(Event)

function ToggleBlock:init(data)
    super.init(self, data)

    local properties = data.properties or {}

    self.block_color = properties["color"] or "red"

    self.on_sprite = properties["onsprite"] or ("world/events/toggleblock_"..self.block_color.."_on")
    self.off_sprite = properties["offsprite"] or ("world/events/toggleblock_"..self.block_color.."_off")

    self.flags = Utils.parsePropertyMultiList("flag", properties)
    self.inverted = properties["inverted"] or false

    self.block_data = {
        ["block_color"] = self.block_color,
        ["on_sprite"] = self.on_sprite,
        ["off_sprite"] = self.off_sprite,
        ["flags"] = self.flags,
        ["inverted"] = self.inverted,
    }

    local w = 0
    while w < self.width / TILE_WIDTH do
        local h = 0
        while h < self.height / TILE_HEIGHT do
            local block = Registry.createEvent("toggleblockobject", self.block_data, self.x + w * TILE_WIDTH, self.y + h * TILE_HEIGHT)
            block:setParent(Game.world)
            block:setLayer(0.2)
            h = h + 1
        end
        w = w + 1
    end
end

return ToggleBlock