local actor, super = Class(Actor, "peter")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Peter"

    -- Width and height for this actor, used to determine its center
    self.width = 180/2
    self.height = 120/2

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 1, 1}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "npcs/peter"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = ""

    -- Sound to play when this actor speaks (optional)
    self.voice = "peter"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = {0,0}

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {}

    -- Table of sprite animations
    self.animations = {}

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {}
end

function actor:onSetSprite(sprite, texture, keep_anim)
    sprite:setScale(0.5, 0.5) -- will have to add on offset to battle somewhere
end

return actor