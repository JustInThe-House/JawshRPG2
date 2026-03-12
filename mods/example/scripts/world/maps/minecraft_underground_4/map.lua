local Map, super = Class(Map)

function Map:onEnter()
  self.shade = Rectangle(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)
  self.shade.color = {0,0,0}
  self.shade.alpha = 0.5
  Game.stage:addChild(self.shade)
  Game:setFlag("smog_clear",Game:getFlag("smog_clear",false))
    Game:setFlag("fought_endermen",Game:getFlag("fought_endermen",false))
    self.enderman_jump = 0

end

function Map:onExit()
  if self.shade ~= nil then
    self.shade:remove()
  end
end

function Map:update()
  self.enderman_jump = self.enderman_jump + DT
  local rand = math.random(1,2)
  local enderman = Game.world:getCharacter("enderman", rand)
  if self.enderman_jump > 1.2 and enderman ~= nil and enderman ~= nil then
    Game.world.timer:tween(0.2, enderman, {y = enderman.y -35}, "out-quad", function ()
      Game.world.timer:tween(0.2, enderman, {y = enderman.y + 35}, "in-quad")
    end)
    self.enderman_jump = 0
  end
end


return Map