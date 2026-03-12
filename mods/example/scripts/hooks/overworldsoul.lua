local OverworldSoul, super = HookSystem.hookScript(OverworldSoul)

function OverworldSoul:init(x, y)
    super.super.init(self, x, y)

    self:setColor(1, 0, 0)

    self.alpha = 0

    --self.layer = BATTLE_LAYERS["soul"]

    self.sprite = Sprite("player/heart_dodge")
    self.sprite:setScale(0.25,0.25)
    self.sprite:setOrigin(0.5, 0.5)
    self.sprite.alpha = 0 -- ??????
    self.sprite.inherit_color = true
    self:addChild(self.sprite)

    self.debug_rect = {-8, -8, 16, 16}

    self.collider = CircleCollider(self, 0, 0, 8)

    self.inv_timer = 0
    self.inv_flash_timer = 0

    self.target_lerp = 0
end

return OverworldSoul