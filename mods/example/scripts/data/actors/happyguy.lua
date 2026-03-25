local actor, super = Class(Actor, "happyguy")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Happy Guy"

    -- Width and height for this actor, used to determine its center
    self.scaling = 0.3
    self.hitbox_scaling = 1 / 3
    self.width = 80 * self.scaling
    self.height = 160 * self.scaling

    --[[124 * self.scaling --originally 80 for the walk
    self.height = 131 * self.scaling]]
    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = { 3, self.height * (1 - self.hitbox_scaling), self.width - 3 * 2, self.height * self.hitbox_scaling }

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = "right"

    -- Path to this actor's sprites (defaults to "")
    self.path = "enemies/happyguy"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"

    -- Sound to play when this actor speaks (optional)
    self.voice = "happyguy"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/happyguy"
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = {-33,-13}

    -- Table of sprite animations
    self.animations = {
        ["walk/down"] = { "down", 0.05, true },
        ["walk/left"] = { "left", 0.05, true },
        ["walk/right"] = { "right", 0.05, true },
        ["walk/up"] = { "up", 0.05, true },
        ["wave"] = { "wave", 0.1, true },
        ["idle"] = { "idle", 0.11, true },
        ["jump"] = { "jump", 0.05, true },
        ["mine"] = { "mine", 0.05, true },
        ["cough"] = { "cough", 0.05, true },

    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Since the width and height is the idle sprite size, the offset is 0,0
        ["walk/down"] = { 0, 0 },
        ["walk/left"] = { 0, 0 },
        ["walk/right"] = { 0, 0 },
        ["walk/up"] = { 0, 0 },
        ["wave"] = { -9, 0 },
        ["idle"] = { 0, 0 },
        ["jump"] = { 20, -24 },
        ["mine"] = { 20, -12 },
        ["cough"] = { 0, 0 },
    }
end

function actor:onSetSprite(sprite, texture, keep_anim)
    sprite:setScale(self.scaling, self.scaling)
end

return actor
