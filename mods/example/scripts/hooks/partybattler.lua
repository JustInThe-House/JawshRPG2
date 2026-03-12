-- includes hooks for:
    -- temporary defense (1 turn), and defense when at high health or at certain proportions of health (low health).
    -- boolean for if you were hit during the turn
    -- ability to gain tp when hurt
    -- custom swoon values
    -- maybe changed "down" text to "fails"

    ---@class PartyBattler : Battler
    ---@field heal_over_time         number How much the battler can heal during a wave
    ---@field heal_over_timer        number timer that sets how quickly heal over times are done

local PartyBattler, super = HookSystem.hookScript(PartyBattler)

function PartyBattler:init(...)
    super.init(self,...)
    self.heal_over_time = 0
    self.heal_over_timer = 0
end


function PartyBattler:calculateDamage(amount)
    local def = self.chara:getStat("defense") + self.chara:getStat("temp_defense") -- adds temporary defense
    if self.defending then
        def = def + self.chara:getStat("temp_defense") -- temp defense doubles if defending. only consistent way i found to apply rehablock bonus. also probably fine becuase the increase technically isnt double due to how damage while defending is calculated.
    end
    -- add defense from other places    
    local max_hp = self.chara:getStat("health")
    local cur_hp = self.chara:getHealth()

    def = def + math.floor((1-cur_hp/max_hp) * self.chara:getStat("oobleck")) -- defense increases as health gets lower
    def = def + math.floor(cur_hp/max_hp) * self.chara:getStat("airbag") -- defense higher at full health
    if select(2,self.chara:checkArmor("dvdcase")) > 0 then
        local fluppy_guard = -1 * self.chara:getStat("fluppy")
        for _,party in ipairs(Game.party) do
            fluppy_guard = fluppy_guard + party:getStat("fluppy")
        end
        def = def + fluppy_guard
    end
    
    amount = amount - def * (math.sqrt(8 *(cur_hp/max_hp)) + 1) -- applies a continuous function of what was once the defense calculation

    if amount <= 0 or def == math.huge then
        amount = 0
    end
    return math.max(MathUtils.round(amount*MathUtils.random(0.95,1.05)), 1)
end


function PartyBattler:hurt(amount, exact, color, options)
    options = options or {}

    local vineboom = false
    for _,party in ipairs(Game.battle.party) do
        if select(2,party.chara:checkArmor("panicbutton")) > 0 then
            vineboom = true
            Game.battle.soul.speed = math.min(Game.battle.soul.speed*1.075,8) -- added this for panicbutton
        end
    end
    if vineboom then
        Assets.playSound("vineboom") end

    local swoon = options["swoon"]

    if not options["all"] then
        Assets.playSound("hurt")
        if not exact then
            amount = self:calculateDamage(amount)
            if self.defending then
                amount = math.ceil((2 * amount) / 3)
            end
            -- we don't have elements right now
            local element = 0
            amount = math.ceil((amount * self:getElementReduction(element)))
        end

        self:removeHealth(amount, swoon)
    else
        -- We're targeting everyone.
        if not exact then
            amount = self:calculateDamage(amount)
            -- we don't have elements right now
            local element = 0
            amount = math.ceil((amount * self:getElementReduction(element)))

            if self.defending then
                amount = math.ceil((3 * amount) / 4) -- Slightly different than the above
            end
        end

        self:removeHealthBroken(amount, swoon) -- Use a separate function for cleanliness
    end

    if (self.chara:getHealth() <= 0) then
        self:statusMessage("msg", swoon and "swoon" or "down", color, true)
    else
        self:statusMessage("damage", amount, color, true)
    end

    self.hurt_timer = 0
    Game.battle:shakeCamera(4)

    if (not self.defending) and (not self.is_down) then
        self.sleeping = false
        self.hurting = true
        self:toggleOverlay(true)
        self.overlay_sprite:setAnimation("battle/hurt", function()
            if self.hurting then
                self.hurting = false
                self:toggleOverlay(false)
            end
        end)
        if not self.overlay_sprite.anim_frames then -- backup if the ID doesn't animate, so it doesn't get stuck with the hurt animation
            Game.battle.timer:after(0.5, function()
                if self.hurting then
                    self.hurting = false
                    self:toggleOverlay(false)
                end
            end)
        end
    end
    local hurt_tp = 0
    for _,party in ipairs(Game.party) do
        hurt_tp = hurt_tp + party:getStat("hurt_tp")
    end
    hurt_tp = hurt_tp * amount
    Game:giveTension(MathUtils.round(hurt_tp)) -- gain tp
    self.chara:addStatBuff("was_hurt", 1) -- hurt "boolean". i could actually make it a boolean, though knowing how many times it was attacked could be useful
end

--- Gets the icon that should display in the Battler's head slot on their action box
---@return string texture
function PartyBattler:getHeadIcon()
    if self.sleeping then
        return "sleep"
    elseif self.defending then
        return "defend"
    elseif self.action and self.action.icon then
        return self.action.icon
    elseif self.hurting then
        return "head_hurt"
    elseif self.is_down then
        return "head_error"
    else
        return "head"
    end
end


function PartyBattler:removeHealth(amount, swoon)
    if (self.chara:getHealth() <= 0) then
        amount = MathUtils.round(amount / 4)
        self.chara:setHealth(self.chara:getHealth() - amount)
    else
        self.chara:setHealth(self.chara:getHealth() - amount)
        if (self.chara:getHealth() <= 0) then
            if swoon then
                if self.chara.id == "jawsh" then
                    self.chara:setHealth(-1987)
                elseif self.chara.id == "berd" then
                    self.chara:setHealth(-131)
                else
                    self.chara:setHealth(-999)
                end
            else
                amount = math.abs((self.chara:getHealth() - (self.chara:getStat("health") / 2)))
                self.chara:setHealth(MathUtils.round(((-self.chara:getStat("health")) / 2)))
            end
        end
    end
    self:checkHealth(swoon)
end


-- this is just stuff to add the down count
--adding both to cover my bases
function PartyBattler:swoon()
    self.is_down = true
    self.chara:addStatBuff("down_count", 1)
    self.sleeping = false
    self.hurting = false
    self:toggleOverlay(true)
    self.overlay_sprite:setAnimation("battle/swooned")
    if self.action then
        Game.battle:removeAction(Game.battle:getPartyIndex(self.chara.id))
    end
    Game.battle:checkGameOver()
end

function PartyBattler:down()
    self.is_down = true
    self.chara:addStatBuff("down_count", 1)
    self.sleeping = false
    self.hurting = false
    self:toggleOverlay(true)
    self.overlay_sprite:setAnimation("battle/defeat")
    if self.action then
        Game.battle:removeAction(Game.battle:getPartyIndex(self.chara.id))
    end
    Game.battle:checkGameOver()
end

return PartyBattler