local spell, super = Class(Spell, "Glare")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Glare"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Weaken\nEnemy"
 
    -- Menu description
    self.description = "Big, scary eyes creep the enemy out.\nLowers the target's defense."

    -- TP cost
    self.cost = 24

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {}
end

function spell:onCast(user, target)
        local eyes = Sprite("emotes/EYES",-40+SCREEN_WIDTH/2,SCREEN_HEIGHT/3)
    eyes:setScaleOrigin(0.5,0.5)
    eyes:setScale(2,2)
    eyes.alpha = 0
    Game.stage:addChild(eyes)
    Game.stage.timer:tween(0.15,eyes, {scale_x = 4, scale_y = 4, })
    Game.stage.timer:tween(0.15,eyes, {alpha = 1 }, "out-quad", function ()
        eyes:fadeOutSpeedAndRemove(0.15)
    end)
    if target.defense >= 1 then
        target.defense = target.defense - 1
    end

end

return spell