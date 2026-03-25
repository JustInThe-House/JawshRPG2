local character, super = Class(PartyMember, "vinny")

function character:init()
    super.init(self)

    -- Display name
    self.name = "Vinny"

    -- Actor (handles sprites)
    self:setActor("vinny")

    -- Display level (saved to the save file)
    self.level = 1
    -- Default title / class (saved to the save file)
    self.title = "Gerblin King.\nSelf-proclaimed\nmud-stacker."


    -- Determines which character the soul comes from (higher number = higher priority)
    self.soul_priority = -1
    -- The color of this character's soul (optional, defaults to red)
    self.soul_color = { 1, 0, 0 }

    -- Whether the party member can act / use spells
    self.has_act = false
    self.has_spells = true

    -- Whether the party member can use their X-Action
    self.has_xact = false
    -- X-Action name (displayed in this character's spell menu)
    self.xact_name = "V-Action"

    -- Spells
    self:addSpell("heal_prayer")
    --self:addSpell("berd_buster")
    self:addSpell("musket_shot")

    -- Current health (saved to the save file)
    self.health = 150
    -- Base stats (saved to the save file)
    self.stats = {
        health = 150,
        attack = 11,
        defense = 0,
        magic = 6
    }
    -- Max stats from level-ups
    self.max_stats = {}


    -- Party members which will also get stronger when this character gets stronger, even if they're not in the party
    self.stronger_absent = {}

    -- Weapon icon in equip menu
    self.weapon_icon = "ui/menu/equip/scarf"

    -- Equipment (saved to the save file)
    self:setWeapon("tophat")

    -- Character color (for action box outline and hp bar)
    self.color = { 0, 0.44, 0 }
    -- Damage color (for the number when attacking enemies) (defaults to the main color)
    self.dmg_color = { 0, 0.67, 0 }
    -- Attack bar color (for the target bar used in attack mode) (defaults to the main color)
    self.attack_bar_color = { 181 / 255, 230 / 255, 29 / 255 }
    -- Attack box color (for the attack area in attack mode) (defaults to darkened main color)
    self.attack_box_color = { 0, 0.5, 0 }
    -- X-Action color (for the color of X-Action menu items) (defaults to the main color)
    self.xact_color = { 0.5, 1, 0.5 }

    -- Head icon in the equip / power menu

    self.menu_icon = "party/vinny/head"
    -- Path to head icons used in battle
    self.head_icons = "party/vinny/icon"
    -- Name sprite (optional)
    self.name_sprite = "party/vinny/name"

    -- Effect shown above enemy after attacking it
    self.attack_sprite = "effects/attack/mash"
    -- Sound played when this character attacks
    self.attack_sound = "laz_c"
    -- Pitch of the attack sound
    self.attack_pitch = 1 --1.15

    -- Battle position offset (optional)
    self.battle_offset = { 0, 0 }
    -- Head icon position offset (optional)
    self.head_icon_offset = nil
    -- Menu icon position offset (optional)
    self.menu_icon_offset = nil

    -- Message shown on gameover (optional)
    self.gameover_message = {
        "This guy phuckin'\nsucks at JRPG2!",
        "Get a [speed:0.25]real[speed:1][wait:5] gamer\nin here!",
        "History major btw",
        "Dream would've beaten\nthat guy."
    }
end

function character:getTitle() return self.title end

function character:getGameOverMessage(main) return TableUtils.pick(self.gameover_message) end

return character
