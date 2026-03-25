local Map, super = Class(Map)

function Map:onEnter()
    Game:setFlag("push_king",Game:getFlag("push_king",false))
end

return Map