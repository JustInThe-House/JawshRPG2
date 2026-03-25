local actor, super = Class(Actor, "pinkiepie")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Pinkie Pie"

    -- Width and height for this actor, used to determine its center
    self.scaling = 0.25
    self.hitbox_scaling = 1/3
    self.width = 100*self.scaling
    self.height = 185*self.scaling

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = { 5, self.height*(1-self.hitbox_scaling), self.width-5-3, self.height*self.hitbox_scaling }

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = "right"

    -- Path to this actor's sprites (defaults to "")
    self.path = "enemies/skeleton"
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
        ["aiming"] = { "noarm", 0.25, true },

    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Since the width and height is the idle sprite size, the offset is 0,0
        ["idle"] = { 0, 0 },
        ["aiming"] = { -20, 0 },
    }
end

function actor:onSetSprite(sprite, texture, keep_anim)
    --this is how you add shaders beforehand
    sprite:setScale(self.scaling, self.scaling) -- will have to add on offset to battle somewhere
        --[[sprite:addFX(ShaderFX("wave", {
                                      ["wave_sine"] = function () return (Kristal.getTime() + 1) * 100 end, --speed of change
                                      ["wave_mag"] = 4, --how much it changes
                                      ["wave_height"] = 4,
                                      ["texsize"] = { SCREEN_WIDTH, SCREEN_HEIGHT }
                                  }))]] 
end

return actor