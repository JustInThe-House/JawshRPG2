local Cough, super = Class(Wave)

function Cough:init()
    super.init(self)

    self.attackers = self:getAttackers()
    self.time = 7
    self.shaking = false
    self.happyguy = Game.battle:getEnemyBattler("happyguy")
    Game.battle.timer:tween(0.4, self.happyguy, {x = SCREEN_WIDTH + 40 })
end

function Cough:onStart()
    self.happyguy.layer = BATTLE_LAYERS["above_bullets"]
    self.happyguy:setPosition(SCREEN_WIDTH/2, SCREEN_HEIGHT - 160)
 --   self.happyguy:setAnimation("walk/up")
    self.timer:tween(0.5, self.happyguy, {y =  self.happyguy.y - 60})
    self.timer:every(1.2, function()
        Assets.playSound("cough", 1 , MathUtils.random(0.8,1.2))
        for _, attacker in ipairs(self.attackers) do
            
            --cough sound, coal fog appear
            -- in harder difficulties, coal fog appears that hides heart

            end
    end)


end

function Cough:update()
    super.update(self)
end

function Cough:onEnd()
    self.happyguy:setAnimation(self.happyguy.reset_sprite)
    self.happyguy:slideTo(self.happyguy.target_x,
                          self.happyguy.target_y, 0.5, "linear") --after function not working for some reason
end

return Cough
