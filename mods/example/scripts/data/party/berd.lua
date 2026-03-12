local character, super = Class(PartyMember, "berd")

function character:init()
    super.init(self)

    -- Display name
    self.name = "Berd"

    -- Actor (handles sprites)
    self:setActor("berd")
  --  self:setLightActor("susie_lw")
  --  self:setDarkTransitionActor("susie_dark_transition")

    -- Display level (saved to the save file)
    self.level = 1
    -- Default title / class (saved to the save file)
    self.title = "Avian Knight.\nGlass cannon with\nbig bird damage."


    -- Determines which character the soul comes from (higher number = higher priority)
    self.soul_priority = 1
    -- The color of this character's soul (optional, defaults to red)
    self.soul_color = {1, 0, 0}

    -- Whether the party member can act / use spells
    self.has_act = false
    self.has_spells = true

    -- Whether the party member can use their X-Action
    self.has_xact = false
    -- X-Action name (displayed in this character's spell menu)
    self.xact_name = "B-Action"

    -- Spells
    self:addSpell("berd_buster")
    -- may add roost ability: heals self, but lowers defense for the turn (this part is hidden)
 

    -- Current health (saved to the save file)
    self.health = 120


    -- Base stats (saved to the save file)

    self.stats = {
        health = 120,
        attack = 16,
        defense = 1,
        magic = 2
    }

    -- Max stats from level-ups

    self.max_stats = {}

    
    -- Party members which will also get stronger when this character gets stronger, even if they're not in the party
    self.stronger_absent = {"jawsh","berd","vinny"}

    -- Weapon icon in equip menu
    self.weapon_icon = "ui/menu/equip/axe"

    -- Equipment (saved to the save file)
    self:setWeapon("mane_ax")

    -- Character color (for action box outline and hp bar)
    self.color = {0.92, 0.92, 0.92}
    -- Damage color (for the number when attacking enemies) (defaults to the main color)
    self.dmg_color = {1, 1, 1}
    -- Attack bar color (for the target bar used in attack mode) (defaults to the main color)
    self.attack_bar_color = {234/255, 121/255, 200/255}
    -- Attack box color (for the attack area in attack mode) (defaults to darkened main color)
    self.attack_box_color = {0.5, 0, 0.5}
    -- X-Action color (for the color of X-Action menu items) (defaults to the main color)
    self.xact_color = {1, 0.5, 1}

    -- Head icon in the equip / power menu
    self.menu_icon = "party/berd/head"
    -- Path to head icons used in battle
    self.head_icons = "party/berd/icon"
    -- Name sprite (optional)
    self.name_sprite = "party/berd/name"

    -- Effect shown above enemy after attacking it
    self.attack_sprite = "effects/attack/mash"
    -- Sound played when this character attacks
    self.attack_sound = "laz_c"
    -- Pitch of the attack sound
    self.attack_pitch = 0.9

    -- Battle position offset (optional)
    self.battle_offset = {3, 1}
    -- Head icon position offset (optional)
    self.head_icon_offset = nil
    -- Menu icon position offset (optional)
    self.menu_icon_offset = nil

    -- Message shown on gameover (optional)
    self.gameover_message = nil -- Handled by getGameOverMessage for Susie

    -- Character flags (saved to the save file)
    self.flags = {
        ["auto_attack"] = false,
    }
end

function character:onTurnStart(battler)
    if self:getFlag("auto_attack", false) then
        Game.battle:pushForcedAction(battler, "AUTOATTACK", Game.battle:getActiveEnemies()[1], nil, {points = 150})
    end
end

function character:onAttackHit(enemy, damage)
    if damage > 0 then
        Assets.playSound("impact", 0.8)
        Game.battle:shakeCamera(4)
    end
end

function character:getGameOverMessage(main)
    return {
        "Come on,[wait:5]\nthat all you got!?",
        main:getName()..",[wait:5]\nget up...!"
    }
end

function character:drawPowerStat(index, x, y, menu)
    if index == 1 then
        local icon = Assets.getTexture("ui/menu/icon/demon")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Rudeness", x, y)
        if Game.chapter == 1 then
            love.graphics.print("99", x+130, y)
        else
            love.graphics.print("89", x+130, y)
        end
        return true
    elseif index == 2 then
        if Game.chapter >= 3 then
            return
        end
        local icon = Assets.getTexture("ui/menu/icon/demon")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        if Game.chapter == 1 then
            love.graphics.print("Crudeness", x, y, 0, 0.8, 1)
            love.graphics.print("100", x+130, y)
        elseif Game.chapter == 2 then
            love.graphics.print("Purple", x, y, 0, 0.8, 1)
            love.graphics.print("Yes", x+130, y)
        end
        return true
    elseif index == 3 then
        local icon = Assets.getTexture("ui/menu/icon/fire")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Guts:", x, y)

        Draw.draw(icon, x+90, y+6, 0, 2, 2)
        Draw.draw(icon, x+110, y+6, 0, 2, 2)
        if Game.chapter >= 3 then
            Draw.draw(icon, x+130, y+6, 0, 2, 2)
        end
        if Game.chapter >= 4 then
            Draw.draw(icon, x+150, y+6, 0, 2, 2)
        end
        return true
    end
end

function character:getTitle() return self.title end

return character
