-- includes hooks for:
    -- temporary defense (1 turn), and defense when at high health or at certain proportions of health (low health).
    -- boolean for if you were hit during the turn
    -- ability to gain tp when hurt
    -- custom swoon values
    -- maybe changed "down" text to "fails"

    ---@class Player : Character, StateManagedClass
    ---@field set_battle_area        number manually sets when in battle area, rather than through rectangles

local Player, super = HookSystem.hookScript(Player)

function Player:update()
    if self.hurt_timer > 0 then
        self.hurt_timer = MathUtils.approach(self.hurt_timer, 0, DTMULT)
    end

    if self.slide_land_timer > 0 and self.state_manager.state ~= "SLIDE" then
        self.slide_land_timer = MathUtils.approach(self.slide_land_timer, 0, DTMULT)
        if self.slide_land_timer == 0 then
            self.slide_sound:stop()
            self.sprite:resetSprite()
            self.slide_lock_movement = false
        end
    end

    self.state_manager:update()

    self:updateHistory()

    if not Game.world.cutscene and not Game.world.menu then
        self.interact_buffer = MathUtils.approach(self.interact_buffer, 0, DT)
    end

    self.world.in_battle_area = false
    if not self.world.in_battle_area and self.set_battle_area then
        self.world.in_battle_area = true
    end
    for _, area in ipairs(self.world.map.battle_areas) do
        if area:collidesWith(self.collider) then
            if not self.world.in_battle_area then
                self.world.in_battle_area = true
            end
            break
        end
    end

    if self.world:inBattle() then
        self.battle_alpha = math.min(self.battle_alpha + (0.04 * DTMULT), 0.8)
    else
        self.battle_alpha = math.max(self.battle_alpha - (0.08 * DTMULT), 0)
    end

    local outlinefx = self.outlinefx --[[@as BattleOutlineFX]]
    outlinefx:setAlpha(self.battle_alpha)

    super.super.update(self)
end

function Player:getBaseWalkSpeed()
    return Game:getFlag("walkingshoes", false) and 5 or 4
end

return Player