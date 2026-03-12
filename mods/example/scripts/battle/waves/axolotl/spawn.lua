local Spawn, super = Class(Wave)

function Spawn:init()
    super.init(self)
    self.time = 1
end

function Spawn:onStart()
    Game.battle:infoText("[font:minecraft,20]Birdie04 spawned Axolotl")
end

function Spawn:onEnd()
    Game.battle.encounter:addEnemy("axolotl",MathUtils.random(550-26,550+20), MathUtils.random(210-50,210+60))
end

return Spawn
