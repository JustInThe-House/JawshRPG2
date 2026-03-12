local smoke, super = Class(Event, "smoke")

function smoke:init(data)
    super.init(self, data)
    self.rx = data.properties["rx"] or 100
    self.ry = data.properties["ry"] or 100
    self.speed = data.properties["speed"] or 1
end

function smoke:onAddToStage(stage)
    super.onAddToStage(self, stage)
    Game.world:spawnBullet("minecraft_smoke_hurt", self.x, self.y, self.rx, self.ry, self.speed)
end

return smoke
