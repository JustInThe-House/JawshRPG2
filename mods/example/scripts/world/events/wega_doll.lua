local wega_doll, super = Class(Event)

function wega_doll:init(data)
    super.init(self, data.center_x, data.center_y, {data.width, data.height})

    self:setOrigin(0.5, 0.5)

    self:setSprite("images/wega_doll")
    self:setScale(0.75,0.75)
    self.siner = MathUtils.random(0,math.pi/4)
    self.siner_speed = MathUtils.random(0.75,1.25)

    self.mouse_collider = CircleCollider(self, data.width/1.5, 1.5*data.height, 16)
end

function wega_doll:onCollide(chara)
    Assets.playSound("item")
    for _, wega in ipairs(Game.world.bullets) do
        wega.speedup = wega.speedup + 0.004
    end
   -- self:setFlag("dont_load", true) to not reload on reenter
    self:remove()
end

function wega_doll:update()
    self.siner = self.siner + DT
    self.y = self.y + math.sin(self.siner*self.siner_speed+math.pi/2)/6
    super.update(self)

end

function wega_doll:draw()
    super.draw(self)
    if DEBUG_RENDER then
        self.mouse_collider:draw(0, 0, 1, 1)
    end
end

return wega_doll