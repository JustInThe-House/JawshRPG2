--includes hooks for removing temporary effects and adding a difficulty. also setting player and enemy spawns
---@class Encounter : Class
---@field difficulty         number    the difficulty level of an attack. makes increasingly difficult attacks easier to code. Enemies don't require it; it is mainly an addition for bosses.
---@field battleroom_upper      string      the top layer that entities "stand" on
---@field battleroom_lower      string      the bottom layer that extends to the bottom of the screen
---@field battleroom_bg      string      what is in the background. ONLY FOR STATIC BACKGROUNDS

local Encounter, super = HookSystem.hookScript(Encounter)

function Encounter:init()
    super.init(self)
    self.difficulty = 0
    self.battleroom_upper = nil
    self.battleroom_lower = nil
    self.battleroom_bg = nil
-- may also add stuff for moving backgrounds, like speed x and y
-- i recall there is a setting that lets you screenwrap, though idk if i can do that for nonsprites
--answwer: you cant! if you want a scrolling one, do this in the encounter file:
--[[function Dummy:onBattleInit()
    local sprite = Sprite('file_path', 0, 0)
    sprite.wrap_texture_x = true
    sprite.physics.speed_x = 8
    sprite.layer = BATTLE_LAYERS["bottom"]
    Game.battle:addChild(sprite)
end]]
end

function Encounter:getPartyPosition(index)
    local positions = { { 140, 170 }, { 110, 240 }, { 60, 320 } } -- 3rd doesnt really matter
    return TableUtils.unpack(positions[index])
end

function Encounter:addEnemy(enemy, x, y, ...)
    local enemy_obj
    if type(enemy) == "string" then
        enemy_obj = Registry.createEnemy(enemy, ...)
    else
        enemy_obj = enemy
    end
    local enemies = self.queued_enemy_spawns
    local enemies_index
    local transition = false
    if Game.battle and Game.state == "BATTLE" then
        enemies = Game.battle.enemies
        enemies_index = Game.battle.enemies_index
        transition = Game.battle.state == "TRANSITION"
    end
    if transition then
        enemy_obj:setPosition(SCREEN_WIDTH + 200, y)
    end
    if x and y then
        enemy_obj.target_x = x
        enemy_obj.target_y = y
        if not transition then
            enemy_obj:setPosition(x, y)
        end
    else
        local x_offset_count, y_offset_count = math.random(-13, 13), 25
        for _, enemy in ipairs(enemies) do
            enemy.target_x = enemy.target_x - x_offset_count
            enemy.target_y = enemy.target_y - y_offset_count
            if not transition then
                enemy.x = enemy.x - x_offset_count
                enemy.y = enemy.y - y_offset_count
            end
        end
        local x, y = 550 + (x_offset_count * #enemies), 210 + (y_offset_count * #enemies)
        enemy_obj.target_x = x
        enemy_obj.target_y = y
        if not transition then
            enemy_obj:setPosition(x, y)
        end
    end
    enemy_obj.encounter = self
    table.insert(enemies, enemy_obj)
    if enemies_index then
        table.insert(enemies_index, enemy_obj)
    end
    if Game.battle and Game.state == "BATTLE" then
        Game.battle:addChild(enemy_obj)
    end
    return enemy_obj
end

function Encounter:onTurnEnd()
    for _, battler in ipairs(Game.battle.party) do
        battler.chara:resetBuff("temp_defense")
        battler.chara:resetBuff("temp_soul_speed")
        battler.chara:addStatBuff("taunt", -1)
        if battler.chara:getStat("taunt") < 1 then
            battler.chara:resetBuff("taunt")
        end

        battler.chara:resetBuff("temp_attack")
        battler.chara:resetBuff("revenge")

        if select(2, battler.chara:checkArmor("glassbrick")) >= 1 and battler.chara:getStat("was_hurt") < 1 then
            battler.chara:addStatBuff("nohit_attack", 1)
            battler.chara:addStatBuff("temp_attack", battler.chara:getStat("nohit_attack"))
        else
            battler.chara:resetBuff("nohit_attack")
        end
        --  Kristal.Console:log(Utils.dump({battler.chara:getStat("undervolt"),battler.chara:getStat("did_attack")}))

        if battler.chara:getStat("did_attack") < 1 then
            battler.chara:resetBuff("undervolt")
            if not battler.is_down and select(2, battler.chara:checkArmor("orangeball")) >= 1 then
                battler:heal(battler.chara:autoHealAmount(), nil, false)
            end
        else
            if battler.chara:checkWeapon("undervoltaxe") then
                battler.chara:addStatBuff("undervolt", 1)
                battler.chara:addStatBuff("temp_attack", battler.chara:getStat("undervolt"))
            end
            --Kristal.Console:log(Utils.dump({ "did attack!" }))
        end
        -- Kristal.Console:log(battler.chara:getStat("undervolt"))


        battler.chara:resetBuff("defending")
        battler.chara:resetBuff("was_hurt")
        battler.chara:resetBuff("did_attack")
    end
end

function Encounter:getDefendTension(battler)
    if self:hasReducedTension() then
        return 3
    end
    return 24 * (1 + battler.chara:getStat("defend_tp"))
end

return Encounter
