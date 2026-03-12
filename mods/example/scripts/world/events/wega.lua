local wega, super = Class(Event)

function wega:init(data)
    super.init(self, data)
end

function wega:onAddToStage(stage)
    super.onAddToStage(self, stage)
    Game.world:spawnBullet("wegabullet", self.x, self.y)
end

return wega