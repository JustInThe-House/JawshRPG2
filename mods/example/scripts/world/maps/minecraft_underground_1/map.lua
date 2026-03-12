local Map, super = Class(Map)

function Map:onEnter()
  self.shade = Rectangle(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)
  self.shade.color = {0,0,0}
  self.shade.alpha = 0.5
  Game.stage:addChild(self.shade)

end

function Map:onExit()
  if self.shade ~= nil then
    self.shade:remove()
  end
end

return Map