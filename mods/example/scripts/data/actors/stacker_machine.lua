local actor, super = Class(Actor, "stacker_machine")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Stacker Machine"

    -- Width and height for this actor, used to determine its center
    self.scaling = 0.75
    self.hitbox_scaling = 1 / 3
    self.width = 44 * self.scaling
    self.height = 87 * self.scaling

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = { 5, self.height * (1 - self.hitbox_scaling), self.width - 5 - 3, self.height * self.hitbox_scaling }

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = { 1, 1, 1 }

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "enemies/stacker"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "idle"

    -- Sound to play when this actor speaks (optional)
    self.voice = nil
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {}

    -- Table of sprite animations
    self.animations = {}

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {}

    self.bounce = 0
end

function actor:onSpriteDraw(sprite)
    if Game.battle.state ~= nil and Game.battle.state ~= "DEFENDING" then
        self.bounce = self.bounce + DT * 2
        sprite.scale_x = sprite.scale_x + math.cos(self.bounce) / 1000
        sprite:setScaleOrigin(math.sin(self.bounce) / 6, 0.5)
        sprite:setShear(0, (math.cos(self.bounce) / 2) ^ 2)
    end
end

function actor:onSetSprite(sprite, texture, keep_anim)
    sprite:setScale(self.scaling, self.scaling)
    sprite:setShearOrigin(0.5, 0.5)
end

return actor
