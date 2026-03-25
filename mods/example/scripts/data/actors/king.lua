local actor, super = Class(Actor, "king")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "King"

    -- Width and height for this actor, used to determine its center
    self.scaling = 0.35
    self.hitbox_scaling = 1/3
    self.width = 160*self.scaling
    self.height = 160*self.scaling

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    local hitbox_width_offset = 17
    local hitbox_height_offset = 7
    self.hitbox = { hitbox_width_offset, self.height*(1-self.hitbox_scaling)-hitbox_height_offset, self.width-hitbox_width_offset*2, self.height*self.hitbox_scaling }

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = "right"

    -- Path to this actor's sprites (defaults to "")
    self.path = "npcs/king"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "idle"

    -- Sound to play when this actor speaks (optional)
    self.voice = nil
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Table of sprite animations
    self.animations = {
        ["idle"] = { "idle", 0.25, true },
        ["falling"] = { "falling", 0.25, true },

    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Since the width and height is the idle sprite size, the offset is 0,0
        ["idle"] = { 0, 0 },
        ["falling"] = { 0, 0 },
    }
end

function actor:onSetSprite(sprite, texture, keep_anim)
    sprite:setScale(self.scaling, self.scaling)
end

return actor