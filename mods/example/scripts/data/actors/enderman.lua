local actor, super = Class(Actor, "enderman")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Enderman"

    -- Width and height for this actor, used to determine its center
    self.scaling = 0.4
    self.width_offset = 5
    self.hitbox_scaling = 1/3
    self.width = 80*self.scaling
    self.height = 160*self.scaling

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = { self.width_offset, self.height*(1-self.hitbox_scaling), self.width-self.width_offset, self.height*self.hitbox_scaling }

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = "right"

    -- Path to this actor's sprites (defaults to "")
    self.path = "enemies/enderman"
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
        ["idle"] = { "idle", MathUtils.random(0.22,0.28), true },

    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Since the width and height is the idle sprite size, the offset is 0,0
        ["idle"] = { 0, 0 },
    }
end

function actor:onSetSprite(sprite, texture, keep_anim)
    sprite:setScale(self.scaling, self.scaling) -- will have to add on offset to battle somewhere
end

return actor