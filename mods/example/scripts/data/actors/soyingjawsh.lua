local actor, super = Class(Actor, "soyingjawsh")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "The Soying Jawsh"

    -- Width and height for this actor, used to determine its center
    self.width = 117
    self.height = 115

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = { 23, 29, 69, 67 }

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "enemies/soyingjawsh"
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
        ["noarm"] = { "noarm", 0.25, true },
        ["slice_prep"] = { "slice/slice", 0.2, false, frames = { "1-2" } },
        ["slice"] = { "slice/slice", 0.1, false, frames = { "3-5" } },
        ["point"] = { "point/point", 0.2, false },
        ["point_reverse"] = { "point/point", 0.2, false, frames = { 5, 4, 3, 2, 1 } },
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Since the width and height is the idle sprite size, the offset is 0,0
        ["idle"] = { 0, 0 },
        ["noarm"] = { 0, 0 },
        ["slice"] = { 0, 0 },
        ["slice_prep"] = { 0, 0 },
        ["point/point"] = {23,95}, --ffs finally it worked
    }
end

function actor:onSetSprite(sprite, texture, keep_anim)
    sprite:setScale(0.25, 0.25) -- will have to add on offset to battle somewhere
end

--[[function actor:createSprite()
    return soyingjawsh_actor(self)
end]]

return actor
