local Map, super = Class(Map)

function Map:onEnter()
	Game:setFlag("minecraft_2_gate_open",Game:getFlag("minecraft_2_gate_open",false))
	Game:setFlag("overpass",Game:getFlag("overpass",false))
end

return Map