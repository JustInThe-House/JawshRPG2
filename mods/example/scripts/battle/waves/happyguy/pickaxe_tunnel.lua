local PickaxeUpdown, super = Class(Wave)

function PickaxeUpdown:init()
    super.init(self)
    self:setArenaSize(142 * 1.5, 142 * 0.75)
    self.time = 8
    self.alpha = 0
    self.shifting = false
    self.timer_shift = 0
end

function PickaxeUpdown:onStart()
    self.timer:every(0.3, function()
        local gap = 70
        local x = SCREEN_WIDTH + 30
        local y = Game.battle.arena.y
        self:spawnBullet("iron_pickaxe_tunnel", x, y + gap, math.pi, 11, -math.pi / 2)
        self:spawnBullet("iron_pickaxe_tunnel", x, y - gap, math.pi, 11, math.pi / 2)
    end)

    self.timer:every(Game.battle.encounter.difficulty >= 2 and 0.8 or Game.battle.encounter.difficulty == 1 and 1 or 1.5, function()
        local top_row = TableUtils.filter(self.bullets, function(e) return e.y <= Game.battle.arena.y end)
        local bottom_row = TableUtils.filter(self.bullets, function(e) return e.y > Game.battle.arena.y end)
        local select_row = TableUtils.pick({ top_row, bottom_row })
        local gap = Game.battle.encounter.difficulty >= 2 and 55 or 51

        for _, bullet in ipairs(select_row) do
            if bullet.state ~= "STOP" then
                bullet.state = "SHIFT"
                self.timer:tween(0.7, bullet, { y = bullet.y + (bullet.y > Game.battle.arena.y and -1 or 1) * gap },
                    "in-back")
                self.timer:tween(0.3, bullet, { y = bullet.y + (bullet.y > Game.battle.arena.y and 1 or -1) * 10 },
                    "linear")
            end
        end
    end)
end

function PickaxeUpdown:update()
    self.alpha = MathUtils.approach(self.alpha, 1, DT / 2)
    super.update(self)
end

return PickaxeUpdown
