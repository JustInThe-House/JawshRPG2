local WegaBullet, super = Class(WorldBullet)

function WegaBullet:init(x, y)
    super.init(self, x, y, "bullets/wega")
    self.physics.direction = 0
    self.speedfixed = 5
    self:setScale(2, 2)
    self.collider = Hitbox(self, self.width/4+5, self.height/2, self.width/2-10, self.height/3-5)
    self.remove_offscreen = false
    self.timer_movement = 0
    self.damage = 999
    self.timer_scream = 0
    self.speedup = 0
end

function WegaBullet:update()
    self.physics.speed = self.speedfixed + self.speedup
    self.timer_scream = self.timer_scream + DT
    self.physics.direction = MathUtils.angle(self.x, self.y, Game.world.soul.x, Game.world.soul.y)

    local distance = math.sqrt(((self.x - Game.world.soul.x) ^ 2) + (self.y - Game.world.soul.y) ^ 2)
    if distance < 500 then
        Game.world.player.set_battle_area = true-- make sure to reset this on exit!
    else
        Game.world.player.set_battle_area = false 
    end
    if self.timer_scream > 1.25 then
        self.timer_scream = 0
        --Kristal.Console:log(Utils.dump(distance))
        Assets.playSound("wega_scream", MathUtils.clamp(100/distance, 0, 1))
    end

    super.update(self)
end

return WegaBullet
