local Map, super = Class(Map)

function Map:onEnter()
  Game:setFlag("cobblegen_puzzle",Game:getFlag("cobblegen_puzzle",false))
  if Game:getFlag("cobblegen_puzzle",false) then
    Game.world.map:getTileLayer("platform").visible = true
  else
    Game.world.map:getTileLayer("platform").visible = false
  end
  self.bg = Sprite("backgrounds/smplive")
  self.bg.layer = WORLD_LAYERS["bottom"]
  self.bg:setParallax(0.1,0.1)
  Game.world:addChild(self.bg)
end

return Map