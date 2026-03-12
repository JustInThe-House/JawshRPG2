local soyingjawsh_arm, super = Class(Sprite, "soyingjawsh_arm")

function soyingjawsh_arm:init(x, y)
    super.init(self, "enemies/soyingjawsh/arm_point/arm_point_2", x, y)
    self.rotation = -math.pi/4
    self.startx = x
    self.starty = y
    self.x = x
    self.y = y
    self.physics.match_rotation = true
    self:setScale(0.25,0.25)
    self:setOrigin(1,0)
    
    self.siner = 0
    self.siner_control = 0

end

function soyingjawsh_arm:update()
    self.siner = self.siner + DT
    self.rotation = self.rotation + math.cos(self.siner)/(360*(1+self.siner_control)) -- will cause issues if chagning fps cap. why? idk
   
   -- self.x = self.startx + 2*math.cos(self.siner*3)
   -- self.y = self.starty + 2*math.sin(self.siner*3)
    super.update(self)
end


return soyingjawsh_arm

