local swords_dance, super = Class(Wave)

function swords_dance:init()
    super.init(self)
    self.time = 9
    self.timer_rate = -0.5
    self.timer_speedup = 0
    self.sword_order = 1

end

function swords_dance:onStart()
    --local pick_table = {1,2,3,4,5,6,7,8,9,10,11,12}
    local pick_table = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}

    for i = 1,17 do
        local r = 100
        local angle = 22.5
        local pick = Utils.pick(pick_table, false, true)
        self:spawnBullet("sword_dance", Game.battle.arena.x + r*math.cos(math.rad(angle*i)), Game.battle.arena.y + r*math.sin(math.rad(angle*i)),r, pick,math.rad(angle*i),i % 2)


    end
end

function swords_dance:update()
self.timer_rate = self.timer_rate + DT*(1+self.sword_order/8)
if self.timer_rate > 1 and self.sword_order <= 12 then
        for _, sword in ipairs(self.bullets) do
            if sword.order == self.sword_order then
            sword.charge = true
       --     sword.rotation = Utils.angle(sword.x, sword.y, Game.battle.soul.x, Game.battle.soul.y)
            sword.physics.match_rotation = true
            sword.can_graze = true
            sword.timer_master = 0
            sword.color = {0.8,0,0.8}
            end
        end
        self.timer_rate = 0
        self.sword_order = self.sword_order + 1
    end
    super.update(self)
end

return swords_dance