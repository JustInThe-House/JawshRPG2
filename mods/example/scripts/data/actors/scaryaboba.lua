local actor, super = Class(Actor, "scaryaboba")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Scary Aboba"

    -- Width and height for this actor, used to determine its center
    self.scaling = 0.4
    self.hitbox_scaling = 1/3
    self.width = 242*self.scaling
    self.height = 112*self.scaling

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = { 5, self.height*(1-self.hitbox_scaling), self.width-5-3, self.height*self.hitbox_scaling }

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 0, 1}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "enemies/scaryaboba"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "idle"

    -- Sound to play when this actor speaks (optional)
    self.voice = nil
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {}

    -- Table of sprite animations
    self.animations = {
        ["idle"] = {"idle", 0.14, true}
    }


    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        ["idle"] = {0,0}
    }
end

function actor:onSetSprite(sprite, texture, keep_anim)
    sprite:setScale(self.scaling,self.scaling)
end

return actor