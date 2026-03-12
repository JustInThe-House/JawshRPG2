local actor, super = Class(Actor, "pyro")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Pyro"

    -- Width and height for this actor, used to determine its center
    self.width = 120
    self.height = 120

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {10, 80, 58, 30}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 1, 1}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "npcs/pyro"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "smile"

    -- Sound to play when this actor speaks (optional)
    self.voice = nil
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/pyro"
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = {-13,-13}

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {}

    -- Table of sprite animations
    self.animations = {}

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        ["smile"] = {0, 0},
        ["aww"] = {0, -20},
        ["hooray"] = {-14, -9},
    }

    self.bounce_style = nil
    self.timer_bounce = 0
    -- setOrigin is normally 0, 0
end

function actor:onSetSprite(sprite, texture, keep_anim)
    self.timer_bounce = 0
    sprite.rotation = 0
    sprite:setOrigin(0,0)
    sprite:setScale(1,1)
    sprite:setRotationOrigin(0.5,0.5)
    if texture == "aww" then
        sprite:setScaleOrigin(0.5,1)
        sprite:setScale(0.25,0.25)
        Game.world.timer:tween(1, sprite, {scale_x = 0.95}, "out-quad")
        Game.world.timer:tween(1, sprite, {scale_y = 0.95}, "out-quad")
        self.bounce_style = "smooth_sine"
    elseif texture == "hooray" then
        self.bounce_style = nil
    elseif texture == "smile" then
        --sprite:setScaleOriginExact(40,105)
        sprite:setScaleOrigin(0.33,4/6)
        sprite:setRotationOrigin(0.6,0.6)

        self.bounce_style = "lean_back"
    end
end

-- onsetsprite add a littel bounce. its easy


function actor:onSpriteDraw(sprite)
    self.timer_bounce = self.timer_bounce + DTMULT
    if self.bounce_style == "smooth_sine" then
        sprite.scale_x = sprite.scale_x + math.cos(self.timer_bounce/5)/150
        sprite.scale_y = sprite.scale_y + math.sin(self.timer_bounce/5)/500
    elseif self.bounce_style == "lean_back" then
        sprite.rotation = sprite.rotation + math.cos(self.timer_bounce/2)/150
        sprite.scale_x = sprite.scale_x + math.cos(self.timer_bounce/2)/120
    end
end

function actor:onTextSound()
            if Mod.voice_timer == 0 then
        local snd = TableUtils.pick({"voice/pyro/voice_1","voice/pyro/voice_2","voice/pyro/voice_3","voice/pyro/voice_4"})
        local pitch = 0.86 + MathUtils.random(0.35)
        Assets.playSound(snd, 0.7, pitch)
        Mod.voice_timer = 3.5
    end
    return true
end

return actor