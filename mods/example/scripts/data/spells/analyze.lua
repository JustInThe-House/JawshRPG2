local spell, super = Class(Spell, "analyze")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Analyze"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Check\nEnemy"

    -- Menu description
    self.description = "Put your brow up and look at the enemy.\nCan provide tips on what to do!"

    -- TP cost
    self.cost = 0

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {}
end

function spell:onStart(user, target)
    Game.battle:battleText(self:getCastMessage(user, target), function()
        -- add change animation to animation end, then do finish action
        Game.battle:finishActionBy(user)
    end)
    user:setAnimation(self:getCastAnimation())
    local analyze = Sprite("emotes/Analyze",-40+SCREEN_WIDTH/2,SCREEN_HEIGHT/3)
    analyze:setScaleOrigin(0.5,0.5)
    analyze:setScale(2,2)
    analyze.alpha = 0
    Game.stage:addChild(analyze)
    Game.stage.timer:tween(0.15,analyze, {scale_x = 4, scale_y = 4, })
    Game.stage.timer:tween(0.15,analyze, {alpha = 1 }, "out-quad", function ()
        analyze:fadeOutSpeedAndRemove(0.15)
    end)
end

function spell:getCastMessage(user, target)
    return target:onAct(user, "Check")
end

return spell
