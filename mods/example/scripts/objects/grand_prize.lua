local grand_prize, super = Class(Sprite, "grand_prize")

function grand_prize:init(x, y)
    super.init(self, "emotes/grand_prize", x, y)
    self.siner = 0
    self:setOrigin(0.5,0.5)
    self.scale_y = 0
    Game.world.timer:tween(1, self, {scale_y = 1})
end

function grand_prize:update()
    self.siner = self.siner + DT
    self.scale_x = math.sin(self.siner * 1.5)
   --self.scale_x = math.sin(self.siner) + math.cos(self.siner)
    super.update(self)
end

return grand_prize
