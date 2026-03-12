local Map, super = Class(Map)

function Map:onEnter()
  Game:setFlag("can_leave_home",Game:getFlag("can_leave_home",0))
end

return Map