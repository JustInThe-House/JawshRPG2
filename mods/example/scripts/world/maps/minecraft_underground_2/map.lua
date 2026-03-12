local Map, super = Class(Map)

function Map:onEnter()
  self.shade = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
  self.shade.color = { 0, 0, 0 }
  self.shade.alpha = 0.5
  Game.stage:addChild(self.shade)
  Game:setFlag("smog_clear", Game:getFlag("smog_clear", false))
  Game:setFlag("happyguy_meet", Game:getFlag("happyguy_meet", false))
end

function Map:onExit()
  if self.shade ~= nil then
    self.shade:remove()
  end
end

return Map
