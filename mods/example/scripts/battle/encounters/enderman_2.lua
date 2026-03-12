local Enderman, super = Class(Encounter)

function Enderman:init()
    super.init(self)

    self.text = "* Blind Endermen teleport in!"

   -- self:addEnemy("virovirokun", 530, 148)
    --self:addEnemy("virovirokun", 560, 262)
    self:addEnemy("enderman")
    self:addEnemy("enderman")

    self.background = true
    self.music = "battle"
end

function Enderman:onBattleStart()
    for _, enemy in pairs(Game.battle.enemy_world_characters) do
        enemy:remove()
    end
end

return Enderman
