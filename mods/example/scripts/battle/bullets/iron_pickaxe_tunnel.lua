local IronPickTunnel, super = Class(Bullet)

function IronPickTunnel:init(x, y, dir, speed, rot)
    super.init(self, x, y, "bullets/iron_pickaxe")
    self.rotation = rot
    self.physics.direction = dir
    self.physics.speed = speed
    self.collider = Hitbox(self, 4, self.height / 4, self.width - 10, self.height / 2)

    self:setScale(1)
    self.destroy_on_hit = false
    self.remove_offscreen = false
    self.siner = MathUtils.random(0, 2 * math.pi)
    self.state = "MOVE"
    self.inv_timer = 0.5
end

function IronPickTunnel:onWaveSpawn(wave)
    self.wave.timer:after(3, function()
        self:remove()
    end)
end

function IronPickTunnel:getDamage()
    return self.damage or (self.attacker and self.attacker.attack * 3.5) or 0
end

function Bullet:getGrazeTension()
    return self.tp or (self.attacker and self.attacker:getGrazeTension()) or 0.8
end

function IronPickTunnel:update()
    self.alpha = self.wave.alpha
    self.siner = self.siner + DT * 4
    self.rotation = self.rotation + math.sin(self.siner) / 200
    if self.state == "MOVE" then
        self.y = self.y + math.sin(self.siner) / 5
    elseif self.state == "SHIFT" then
        --self.physics.speed = self.physics.speed - DT * 4
        --self.wave.timer:after(0.4, function ()
        -- self.physics.speed = self.physics.speed + DT * 2
        --self.wave.timer:after(0.3, function ()
        self.state = "STOP"
        --self.physics.speed = 0
        --   end)
        -- end)
    end

    super.update(self)
end


return IronPickTunnel
