local Vents, super = Class(Event)

function Vents:init(data)
    super.init(self, data)
self.smoking = not Game:getFlag("smog_clear", false)
self.siner = MathUtils.random(0,2*math.pi)
end

function Vents:onAddToStage(stage)
super.onAddToStage(self,stage)
Game.world.timer:every(0.25, function ()
    if self.smoking then
        self.siner = self.siner + DT*50
        Game.world:spawnBullet("minecraft_smoke", self.x+20, self.y+20, -math.pi/2 + math.cos(self.siner)/2)
    end
end)
end

function Vents:onRemoveFromStage(stage)
    self.smoking = false
    super.onRemoveFromStage(self,stage)
end

return Vents