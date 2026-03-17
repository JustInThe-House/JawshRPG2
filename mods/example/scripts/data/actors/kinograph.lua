local actor, super = Class(Actor, "kinograph")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Kinograph"

    -- Width and height for this actor, used to determine its center
    self.scaling = 1.3
    self.hitbox_scaling = 2 / 3
    self.width = 40 * self.scaling
    self.height = 40 * self.scaling

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = { 0, self.height * (1 - self.hitbox_scaling), self.width - 0, self.height * self.hitbox_scaling }

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = "right"

    -- Path to this actor's sprites (defaults to "")
    self.path = "enemies/kinograph"
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

function actor:onSpriteInit(sprite)
    sprite.sum = 0
    sprite.last_positions = {}
    sprite.sample_timer = 0
    sprite.max_line_length = 25
    sprite.line_y_offset = 20
end

function actor:onSpriteUpdate(sprite)
    sprite.sample_timer = sprite.sample_timer + DT

    -- normal distribution
    if sprite.sample_timer > 0.05 then
        local u1, u2 = MathUtils.random(0, 1), MathUtils.random(0, 1)
        local rand = math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2)
        sprite.sum = sprite.sum + rand - DT * 2
        if sprite.sum > 17 or sprite.sum < -20 then
            sprite.sum = MathUtils.approach(sprite.sum, 0, 100 * DT)
        end
        table.insert(sprite.last_positions, 1, sprite.sum+sprite.line_y_offset)
        if #sprite.last_positions > sprite.max_line_length then
            table.remove(sprite.last_positions)
        end
        sprite.sample_timer = 0
    end
end

function actor:onSpriteDraw(sprite)
    local head = Assets.getTexture("enemies/kinograph/head")
    local line = Assets.getTexture("bullets/pixel")
    
    for index, pixel in ipairs(sprite.last_positions) do
        Draw.setColor(1, 0, 0, 1)
        Draw.draw(line, 28 - index, pixel, 0, 1, 1)
        Draw.setColor(1, 0, 0, 0.5)
        Draw.draw(line, 28 - index + 0.4, pixel - 0.3, 0, 1, 1)
    end
    Draw.setColor(1, 1, 1, 1)
    Draw.draw(head, 22, 10 + sprite.sum, 0, 0.2, 0.2)
end

return actor
