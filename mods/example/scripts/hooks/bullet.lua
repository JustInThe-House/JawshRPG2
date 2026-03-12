-- changed base set scale and made it so bullets wont be destroyed colliding with an invulnerable soul

local Bullet, super = HookSystem.hookScript(Bullet)

function Bullet:init(x, y, texture)
    super.super.init(self, x, y)

    self.layer = BATTLE_LAYERS["bullets"]

    -- Set scale and origin
    self:setOrigin(0.5, 0.5)
--    self:setScale(2, 2)
    self:setScale(1, 1)

    -- Add a sprite, if we provide one
    if texture then
        self:setSprite(texture, 0.25, true)
    end

    -- Default collider to half this object's size
    self.collider = Hitbox(self, self.width/4, self.height/4, self.width/2, self.height/2)

    -- TP added when you graze this bullet (Also given each frame after the first graze, 30x less at 30FPS)
    self.tp = nil
    -- Whether you can graze this bullet or not.
    self.can_graze = true
    -- Whether this bullet has already been grazed (reduces graze rewards).
    self.grazed = false
    -- Turn time reduced when you graze this bullet (Also applied each frame after the first graze, 30x less at 30FPS)
    self.time_bonus = 1

    -- Damage given to the player when hit by this bullet (Defaults to 5x the attacker's attack stat)
    self.damage = nil
    -- Invulnerability timer to apply to the player when hit by this bullet (Defaults to 4/3 seconds)
    self.inv_timer = (4 / 3)
    -- Whether this bullet gets removed on collision with the player (Defaults to `true`)
    self.destroy_on_hit = true

    -- Whether to remove this bullet when it goes offscreen (Defaults to `true`)
    self.remove_offscreen = true
end

function Bullet:onCollide(soul)
    if soul.inv_timer == 0 then
        self:onDamage(soul)
        if self.destroy_on_hit then
            self:remove()
        end
    end
end

return Bullet