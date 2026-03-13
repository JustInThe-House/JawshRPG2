local Map, super = Class(Map)

function Map:onEnter()
  Game:setFlag("met_vinny",Game:getFlag("met_vinny",false))
end

return Map