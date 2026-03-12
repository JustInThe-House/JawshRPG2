local Cobblegen, super = Class(Wave)

function Cobblegen:init()
    super.init(self)
    self:setArenaShape({ 0, 0 }, { 240, 0 }, { 240, 40 }, { 200, 40 }, { 200, 80 }, { 40, 80 }, { 40, 40 }, { 0, 40 })
    self:setSoulOffset(0, -20)
    self.time = math.huge
    self.block = nil
    self.x_location = 0
    self.hole_x = 320
end

function Cobblegen:onStart()
    self.arena_center_x, self.arena_center_y = Game.battle.arena:getCenter()
    Game.battle:infoText("* Build a cobblestone generator!")
    local bg = Sprite("bullets/cobblegen/cobblegen_base", 0, 40)
    Game.battle.arena:addChild(bg)
    self.timer:after(2.5, function()
        self.block = "water"
        Game.battle.soul:setExactPosition(self.arena_center_x, self.arena_center_y - 20)
        self.placeblock_water = self:spawnBullet("cobblegen/water", Game.battle.soul.x, Game.battle.soul.y, true)
        Game.battle:infoText("* Where does the water go?")
    end)
end

function Cobblegen:update()
    local arena = Game.battle.arena
    if self.block ~= nil then
        if self.block == "water" and self.placeblock_water.placed then
            self.block = "lava"
            Assets.playSound("noise")
            Game.battle.soul:setExactPosition(self.arena_center_x, self.arena_center_y - 30)
            self.timer:after(1.5, function()
                self.placeblock_lava = self:spawnBullet("cobblegen/lava", Game.battle.soul.x, Game.battle.soul.y,
                                                        true)
                Game.battle:infoText("* Where does the lava go?")
            end)
        elseif self.block == "lava" and self.placeblock_lava ~= nil and self.placeblock_lava.placed then
            self.block = "check"
            Assets.playSound("noise")
            Game.battle.soul:setExactPosition(self.arena_center_x, self.arena_center_y - 30)
            if self.block == "check" then
                self.block = "done"
                self.timer:after(2, function()
                    if self.placeblock_water.x == 380 and self.placeblock_lava.x == 260 then
                        Assets.playSound("HOORAY")
                        Game.battle:infoText("* You did it!")
                        self:spawnBullet("cobblegen/lava", arena:getLeft() + 80 + 20, arena:getTop() + 40 + 20, false)

                        self.timer:after(3, function()
                            Game.battle:setState("VICTORY")
                            Game.battle:setState("TRANSITIONOUT")
                        end)
                        local cobblestone = Sprite("bullets/cobblegen/cobblestone", 120, 40)
                        Game.battle.arena:addChild(cobblestone)
                    else
                        self.placeblock_lava:setSprite("bullets/cobblegen/obsidian", 0.25, true)
                        self.placeblock_lava.layer = self.placeblock_lava.layer + 2
                        Assets.playSound("minecraft/fire_hurt", 1, 0.5)
                        Assets.playSound("error")
                        Game.battle:infoText("* FAILS")
                        self.timer:after(1.5, function()
                            Assets.playSound("hurt")
                            local main_chara = Game:getSoulPartyMember()
                            Game:gameOver(Game.battle.party[Game.battle:getPartyIndex(main_chara.id)].x,
                                          Game.battle.party[Game.battle:getPartyIndex(main_chara.id)].y)
                        end)
                        if self.placeblock_lava.x == 260 then
                            self:spawnBullet("cobblegen/water", arena:getLeft() + 80 + 20, arena:getTop() + 40 + 20,
                                             false)
                            self:spawnBullet("cobblegen/water", arena:getLeft() + 120 + 20, arena:getTop() + 40 + 20,
                                             false)
                            self:spawnBullet("cobblegen/water", arena:getLeft() + 120 + 20, arena:getTop() + 80 + 20,
                                             false)
                            self:spawnBullet("cobblegen/water", arena:getLeft() + 160 + 20, arena:getTop() + 40 + 20,
                                             false)
                        elseif self.placeblock_lava.x == 300 and self.placeblock_water.x >= 340 then
                            self:spawnBullet("cobblegen/water", arena:getLeft() + 120 + 20, arena:getTop() + 40 + 20,
                                             false)
                            self:spawnBullet("cobblegen/water", arena:getLeft() + 120 + 20, arena:getTop() + 80 + 20,
                                             false)
                            self:spawnBullet("cobblegen/water", arena:getLeft() + 160 + 20, arena:getTop() + 40 + 20,
                                             false)
                        elseif self.placeblock_lava.x == 340 and self.placeblock_water.x <= 300 then
                            self:spawnBullet("cobblegen/water", arena:getLeft() + 40 + 20, arena:getTop() + 40 + 20,
                                             false)
                            self:spawnBullet("cobblegen/water", arena:getLeft() + 80 + 20, arena:getTop() + 40 + 20,
                                             false)
                        elseif self.placeblock_lava.x == 380 then
                            self:spawnBullet("cobblegen/water", arena:getLeft() + 40 + 20, arena:getTop() + 40 + 20,
                                             false)
                            self:spawnBullet("cobblegen/water", arena:getLeft() + 80 + 20, arena:getTop() + 40 + 20,
                                             false)
                            self:spawnBullet("cobblegen/water", arena:getLeft() + 120 + 20, arena:getTop() + 40 + 20,
                                             false)
                            self:spawnBullet("cobblegen/water", arena:getLeft() + 120 + 20, arena:getTop() + 80 + 20,
                                             false)
                        end
                    end
                end)
            end
        end
    end
    super.update(self)
end

return Cobblegen
