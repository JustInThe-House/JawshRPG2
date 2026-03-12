local fountain, super = Class(Wave)

function fountain:onStart()
    self.time = 8
    
    self.timer:every(1, function()
        local x = Utils.random(Game.battle.arena.left, Game.battle.arena.right)
        -- Get a random Y position between the top and the bottom of the arena
        local y = Utils.random(Game.battle.arena.bottom + 20, Game.battle.arena.bottom) + 40

        -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
        local bullet = self:spawnBullet("smallbullet", x, y, math.rad(270), 10)

        -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
   --     local bullet = self:spawnBullet("smallbullet", x, y, math.rad(0), 8)

            self.timer:after(0.4, function ()
                self:spawnBullet("smallbullet", x, y, math.rad(270), 7)
        end)
            self.timer:after(0.5, function ()
                self:spawnBullet("smallbullet", x, y, math.rad(255), 6)
                self:spawnBullet("smallbullet", x, y, math.rad(285), 6)  
                self:spawnBullet("smallbullet", x, y, math.rad(315), 7)
                self:spawnBullet("smallbullet", x, y, math.rad(225), 7)  
                self:spawnBullet("smallbullet", x, y, math.rad(340), 6)
                self:spawnBullet("smallbullet", x, y, math.rad(200), 6)  
        end)    



        -- Dont remove the bullet offscreen, because we spawn it offscreen
        bullet.remove_offscreen = false
    end)
end

function fountain:update()
    -- Code here gets called every frame

    super.update(self)
end

return fountain