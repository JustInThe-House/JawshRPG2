local Map, super = Class(Map)

function Map:onEnter()
  Game:setFlag("poniko_flicker", "false")
  Game:setFlag("poniko_dark", "false")
  Game:setFlag("poniko_scary", "false")
end

return Map