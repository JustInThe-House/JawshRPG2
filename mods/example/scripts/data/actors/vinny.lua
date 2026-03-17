local actor, super = Class(Actor, "vinny")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Vinny"

    -- Width and height for this actor, used to determine its center
    self.width = 22
    self.height = 34

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {4, 22, 14, 12}
    
    -- A table that defines where the Soul should be placed on this actor if they are a player.
    -- First value is x, second value is y.
    self.soul_offset = {10.5, 24}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {0, 1, 0}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/vinny/dark"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"

    -- Sound to play when this actor speaks (optional)
    self.voice = "vinny"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/vinny"
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = {-33,-13}

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {
        -- Movement animations
        ["slide"]               = {"slide", 4/30, true},

        -- Battle animations
        ["battle/idle"]         = {"battle/idle", 0.2, true},

        ["battle/attack"]       = {"battle/attack", 1/30, false},
        ["battle/act"]          = {"battle/act", 1/15, false},
        ["battle/spell"]        = {"battle/item", 1/15, false, next="battle/idle"},-- battle/spell
        ["battle/item"]         = {"battle/item", 1/12, false, next="battle/idle"},
        ["battle/spare"]        = {"battle/item", 1/15, false, next="battle/idle"}, -- battle/spell

        ["battle/attack_ready"] = {"battle/attackready", 0.25, true},
        ["battle/act_ready"]    = {"battle/actready", 0.2, true},
        ["battle/spell_ready"]  = {"battle/actready", 0.2, true},
        ["battle/item_ready"]   = {"battle/itemready", 0.2, true},
        ["battle/defend_ready"] = {"battle/defend", 1/15, false},

        ["battle/act_end"]      = {"battle/actend", 1/15, false, next="battle/idle"},

        ["battle/hurt"]         = {"battle/hurt", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]       = {"battle/defeat", 1/15, false},
        ["battle/swooned"]      = {"battle/defeat", 1/15, false},

        ["battle/transition"]   = {"walk/right_1", 1/15, false},
        ["battle/intro"]        = {"battle/intro", 1/30, false},
        ["battle/victory"]      = {"battle/victory", 1/10, false},

    }

    -- Tables of sprites to change into in mirrors
    self.mirror_sprites = {
        ["walk/down"] = "walk/up",
        ["walk/up"] = "walk/down",
        ["walk/left"] = "walk/left",
        ["walk/right"] = "walk/right",
        
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Movement offsets
        ["walk/down"] = {-1, 0},
        ["walk/left"] = {3, 0},
        ["walk/right"] = {0, 0},
        ["walk/up"] = {-1, 1},

        ["slide"] = {-2, 2},

        -- Battle offsets
        ["battle/idle"] = {0, 0},

        ["battle/attack"] = {0, 0},
        ["battle/attackready"] = {0, 0},
        ["battle/act"] = {0, 0},
        ["battle/actend"] = {0, 0},
        ["battle/actready"] = {0, 0},
        ["battle/spell"] = {0, 0},
        ["battle/spellready"] = {0, 0},
        ["battle/item"] = {0, 0},
        ["battle/itemready"] = {0, 0},
        ["battle/defend"] = {-1, 0},
        ["battle/swooned"] = {0, 0},

        ["battle/defeat"] = {-3, 6}, --needs work
        ["battle/hurt"] = {-1, 0},

        ["battle/intro"] = {0, 0},
        ["battle/victory"] = {0, 0},


    }
end

--[[function actor:onTextSound()
        local pitch = 1.05 --+ MathUtils.random(0.35)
        Assets.playSound("voice/vinny", 1, pitch)
    return true
end
]]
return actor