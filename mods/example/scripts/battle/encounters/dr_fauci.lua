local DrFauci, super = Class(Encounter)

function DrFauci:init()
    super.init(self)

    self.text = "* Dr. Anthony Fauci."

    self:addEnemy("dr_fauci")

    self.background = true
    self.music = "battle"
    Game.battle.music.volume = 0

    Game.battle.timer:after(0.4, function()
        Assets.playSound("dranthonyfauci")
    end)
    Game.battle.timer:after(17, function()
        Game.battle.music:fade(1, 3)
    end)
end

return DrFauci
