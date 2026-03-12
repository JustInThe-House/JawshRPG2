local character, super = Class(PartyMember, "jawsh")

function character:init()
    super.init(self)

    -- Display name
    self.name = "Jawsh"

    -- Actor (handles overworld/battle sprites)
    self:setActor("jawsh")
    self:setLightActor("jawsh_real")
--    self:setDarkTransitionActor("kris_dark_transition")

    -- Display level (saved to the save file)
    self.level = 1
    -- Default title / class (saved to the save file)

    self.title = "Leader with a\nHEART of iron\nand fists of steel."


    -- Determines which character the soul comes from (higher number = higher priority)
    self.soul_priority = 2
    -- The color of this character's soul (optional, defaults to red)
    self.soul_color = {1, 0.5, 0}

    -- Whether the party member can act / use spells
    self.has_act = false
    self.has_spells = true

    -- Whether the party member can use their X-Action
    self.has_xact = false
    -- X-Action name (displayed in this character's spell menu)
    self.xact_name = "J-Action"

    -- Spells
    self:addSpell("analyze")
    --self:addSpell("power_punch")
    self:addSpell("bljitter")
    --self:addSpell("jeep_crash")

    -- Current health (saved to the save file)

    self.health = 200

    -- Base stats (saved to the save file)
    self.stats = {
        health = 200,
        attack = 6,
        defense = 4,
        magic = 0
    }

    -- Max stats from level-ups
    self.max_stats = {}

    -- Party members which will also get stronger when this character gets stronger, even if they're not in the party
    self.stronger_absent = {}

    -- Weapon icon in equip menu
    self.weapon_icon = "ui/menu/equip/sword"

    -- Equipment (saved to the save file)
    self:setWeapon("whitegloves")
    --    self:setArmor(1, "amber_card")



    -- Character color (for action box outline and hp bar)
    self.color = {1, 0.55, 0.1}
    -- Damage color (for the number when attacking enemies) (defaults to the main color)
    self.dmg_color = {1, 0.67, 0.34}
    -- Attack bar color (for the target bar used in attack mode) (defaults to the main color)
    self.attack_bar_color = {0, 162/255, 232/255}
    -- Attack box color (for the attack area in attack mode) (defaults to darkened main color)
    self.attack_box_color = {0, 0, 1}
    -- X-Action color (for the color of X-Action menu items) (defaults to the main color)
    self.xact_color = {0.5, 1, 1}

    -- Head icon in the equip / power menu
    self.menu_icon = "party/jawsh/head"
    -- Path to head icons used in battle
    self.head_icons = "party/jawsh/icon"
    -- Name sprite
    self.name_sprite = "party/jawsh/name"

    -- Effect shown above enemy after attacking it
    self.attack_sprite = "effects/attack/slap_r" --cut
    -- Sound played when this character attacks
    self.attack_sound = "laz_c"
    -- Pitch of the attack sound
    self.attack_pitch = 0.9

    -- Battle position offset (optional)
    self.battle_offset = {0, 0}
    -- Head icon position offset (optional)
    self.head_icon_offset = nil
    -- Menu icon position offset (optional)
    self.menu_icon_offset = nil

    -- Message shown on gameover (optional)
    self.gameover_message = {
        "This game sucks.",
        "Why am I still playing this?",
        "It's LITERALLY eating\nmy inputs!"
    }
end

--[[function character:drawPowerStat(index, x, y, menu)
    if index == 1 and menu.kris_dog then
        local frames = Assets.getFrames("misc/dog_sleep")
        local frame = math.floor(Kristal.getTime()) % #frames + 1
        love.graphics.print("Dog:", x, y)
        Draw.draw(frames[frame], x+120, y+5, 0, 2, 2)
        return true
    elseif index == 3 then
        local icon = Assets.getTexture("ui/menu/icon/fire")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Guts:", x, y)

        Draw.draw(icon, x+90, y+6, 0, 2, 2)
        if Game.chapter >= 2 then
            Draw.draw(icon, x+110, y+6, 0, 2, 2)
        end
        if Game.chapter >= 4 then
            Draw.draw(icon, x+130, y+6, 0, 2, 2)
        end
        return true
    end
end]]

function character:getTitle() return self.title end

function character:getGameOverMessage(main) return TableUtils.pick(self.gameover_message) end

return character