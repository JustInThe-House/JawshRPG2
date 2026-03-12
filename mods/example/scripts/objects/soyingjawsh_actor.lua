local soyingjawsh, super = Class(ActorSprite)

function soyingjawsh:init(actor)
    super.init(self, actor)

    self.body = Sprite("enemies/soyingjawsh/idle")
    self.body.id = "body"
    self.body.layer = -5
    --self.body:setScale(0.25,0.25)
    self:addChild(self.body)

    self.arm = Sprite("enemies/soyingjawsh/arm_point/arm_point_2", 250, 170)
    self.arm:setOrigin(1,0)
    self.arm.rotation = -math.pi/4
    self.arm.startrotation = self.arm.rotation
    self.arm.startx, self.arm.starty = self.arm.x, self.arm.y
    self.arm.id = "arm"
    self.arm.layer = -10
   -- self.arm:setScale(0.25,0.25)
    self:addChild(self.arm)

    self.parts = {
        self.arm,
        self.body,
    }

end

return soyingjawsh