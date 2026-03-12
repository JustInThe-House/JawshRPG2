--- A Toggleable Block! Has collision when on and doesn't when off!
--- `ToggleBlockObject` is an [`Event`](lua://Event.init) - naming an object `toggleblockobject` on an `objects` layer in a map creates this object. \
--- WARNING: You're not really meant to use this one, use 'toggleblock' instead.
--- See this object's Fields for the configurable properties on this object.
--- 
---@class ToggleBlockObject : Event
---
---@field block_color       string      *[Property `color`]* The color of the block, changes the sprite to the default 6 sprites, defaults to red
---@field on_sprite         string      *[Property `onsprite`]* An optional custom on the block should use
---@field off_sprite        string      *[Property `offsprite`]* An optional custom off sprite the block uses
---
---@field flags             table       *[Property `flag`]* The name of the flag(s) to check for whether targets should be active, if any of them are true the blocks will active - if `!` is at the start of the flag, the check will be [`inverted`]
---@field inverted          boolean     *[Property `inverted`]* Whether the flagcheck is inverted such that if `flag` is `flag_value`, the blocks are inactive, and active otherwise
---
---@field on                boolean     If the block is on or off
---
---@overload fun(...) : ToggleBlockObject
local ToggleBlockObject, super = Class(Event)

function ToggleBlockObject:init(block_data, x, y)
    super.init(self, x, y, {TILE_WIDTH, TILE_HEIGHT})

    block_data = block_data or {}
    self.block_color = block_data["block_color"] or "red"

    self.on_sprite = block_data["on_sprite"] or ("world/events/toggleblock_"..self.block_color.."_on")
    self.off_sprite = block_data["off_sprite"] or ("world/events/toggleblock_"..self.block_color.."_off")

    self.flags = block_data["flags"] or {}
    self.inverted = block_data["inverted"] or false

    self:setSprite(self.on_sprite)
    self.solid = true
    self.collidable = true
end

function ToggleBlockObject:update()
    if self.flags ~= {} then
        local flagValue = false
        for i, flags in ipairs(self.flags) do
            for j, flag in ipairs(flags) do
                if Game:getFlag(flag, false) or (self.world and self.world.map:getFlag(flag, false)) then
                    flagValue = true
                end
            end
        end

        if self.inverted then
            flagValue = not flagValue
        end

        if flagValue then
            self.on = true;
            self:turnedOn()
        else
            self.on = false;
            self:turnedOff()
        end
    end

    self:checkPlayerCollision()
    self:checkBlockCollision()
    super.update(self)
end

--- *(Override)* Called when the block is on
function ToggleBlockObject:turnedOn()
    self.collidable = true
    self.solid = true
    self:setSprite(self.on_sprite)
end

--- *(Override)* Called when the block is off
function ToggleBlockObject:turnedOff()
    self.collidable = false
    self.solid = false
    self:setSprite(self.off_sprite)
end

--- *(Override)* Called every frame to check if a block is stuck in it
function ToggleBlockObject:checkBlockCollision()
    if self.on then
        for i, block in ipairs(Game.world:getEvents("pushblock")) do
            if math.abs(self.x - block.x) < TILE_WIDTH / 2 and math.abs(self.y - block.y) < TILE_HEIGHT / 2 then
                for j, warp in ipairs(Game.world:getEvents("blockwarp")) do
                    if warp.linked_block == block.object_id then
                        warp:warpBlock(block)
                    end
                end
            end
        end
    end
end

--- *(Override)* Called every frame to check if the player is stuck in it
function ToggleBlockObject:checkPlayerCollision()
    if self.on then
        if self:collidesWith(Game.world.player) then
            for i, warp in ipairs(Game.world:getEvents("playerwarp")) do
                warp:warpPlayer()
            end
        end
    end
end

return ToggleBlockObject