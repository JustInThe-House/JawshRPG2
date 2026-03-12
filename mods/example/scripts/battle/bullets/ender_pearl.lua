local Pearl, super = Class(Bullet)

function Pearl:init(x, y, dir, speed)
    super.init(self, x, y, "bullets/ender_pearl")

    self.physics.direction = dir
    self.physics.speed = speed
    self.collider = CircleCollider(self, self.width / 2, self.height / 2, self.width / 2 - 2)
    self:setScale(2, 2)
    self.timer_teleport = -0.5
    self.remove_offscreen = false
    self.destroy_on_hit = false
end

function Pearl:onWaveSpawn(wave)
    local sprite_to_afterimage = self.sprite
    self.wave.timer:every(0.15, function ()
        if not sprite_to_afterimage then
            return false
        end
        local after_image = AfterImage(sprite_to_afterimage, 0.4)
        sprite_to_afterimage:addChild(after_image)
    end)
end

function Pearl:update()
    self.timer_teleport = self.timer_teleport + DT
    if self.timer_teleport > 1 then
        self.timer_teleport = 0
        Assets.playSound("minecraft/portal2")
        self.wave.timer:tween(0.25, self, { scale_x = 0, scale_y = 0 }, "linear", function()
            self.wave.timer:tween(0.25, self, { scale_x = 2, scale_y = 2 })
            self.grazed = false
            local space_from_arena = 180
            local rand_angle = MathUtils.random(0, 2 * math.pi)
            self.x = Game.battle.arena.x + space_from_arena * math.cos(rand_angle)
            self.y = Game.battle.arena.y + space_from_arena * math.sin(rand_angle)

            --[[if rand == 0 then
                self.x_set = MathUtils.random(Game.battle.arena:getLeft() - space_from_arena, Game.battle.arena:getRight() + space_from_arena)
                self.y_set = TableUtils.pick({ Game.battle.arena:getTop() - space_from_arena, Game.battle.arena:getBottom() + space_from_arena })
            else
                self.x_set = TableUtils.pick({ Game.battle.arena:getLeft() - space_from_arena, Game.battle.arena:getRight() + space_from_arena })
                self.y_set = MathUtils.random(Game.battle.arena:getTop() - space_from_arena, Game.battle.arena:getBottom() + space_from_arena)
            end]]
            -- self.x, self.y = self.x_set, self.y_set
            -- setting things in a square formation relative to the arena. could be useful
            self.physics.direction = MathUtils.angle(self.x, self.y, Game.battle.soul.x,
                                                     Game.battle.soul.y)
            Assets.playSound("minecraft/portal")
        end)
    end

    super.update(self)
end

return Pearl
