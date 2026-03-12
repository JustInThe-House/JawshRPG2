local IronPickSpin, super = Class(Bullet)

function IronPickSpin:init(x, y, dir)
    super.init(self, x, y, "bullets/iron_pickaxe")
    self.rotation = dir
    self.alpha = 0
    self:setScale(0.5)
    self.destroy_on_hit = false
    self.remove_offscreen = false
    self.siner = MathUtils.random(0, 2 * math.pi)
    self.sound = Assets.newSound("minecraft/wind")
    self.sound:setVolume(0)
    self.sound:play()
    self.dropping = true
end

function IronPickSpin:onWaveSpawn(wave)
    local sprite_to_afterimage = self.sprite

    self.wave.timer:every(0.15, function()
        if not sprite_to_afterimage then
            return false
        end
        local after_image = AfterImage(sprite_to_afterimage, 0.4)
        sprite_to_afterimage:addChild(after_image)
    end)
end

function IronPickSpin:update()
    local soul = Game.battle.soul
    local arena = Game.battle.arena

    if not self.dropping then
        local orbit = MathUtils.angle(self.x, self.y, arena.x, arena.y)
        self.physics.gravity_direction = orbit
        self.siner = self.siner + DT
        self.physics.direction = self.physics.direction + DT * math.cos(self.siner) * 0.4
        self.rotation = self.rotation + DT * (5 + 8 * math.cos(self.siner)^2)
        self.sound:setVolume(2 * math.cos(self.siner)^2)
        self.sound:setPitch(1 + math.cos(self.siner)^2)
    end
    super.update(self)
end

function IronPickSpin:onRemove(parent)
    self.sound:stop()
end

function IronPickSpin:onGraze(first)
    if first == true then
        self.wave.timer:after(0.5, function()
            self.grazed = false
        end)
    end
end

return IronPickSpin
