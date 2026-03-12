local actor, super = Class(Actor, "jawsh")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Jawsh"

    -- Width and height for this actor, used to determine its center
    self.width = 16
    self.height = 32
    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {1, 20, 14, 12}

    -- A table that defines where the Soul should be placed on this actor if they are a player.
    -- First value is x, second value is y.
   -- self.soul_offset = {2, 4}
self.soul_offset = {8, 8}
    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {0, 1, 1}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/jawsh/dark"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"

    -- Sound to play when this actor speaks (optional)
    self.voice = "jawsh"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/jawsh"
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = {-30,-13}

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {
        -- Movement animations
        ["slide"]               = {"slide", 4/30, true},

        -- Battle animations
        ["battle/idle"]         = {"battle/idle", 0.2, true},

        ["battle/attack"]       = {"battle/attack", 1/15, false},
        ["battle/act"]          = {"battle/act", 1/15, false},
        ["battle/spell"]        = {"battle/act", 1/15, false},
        ["battle/item"]         = {"battle/item", 0.1, false, next="battle/idle"}, --1/12
        ["battle/spare"]        = {"battle/act", 1/15, false, next="battle/idle"},

        ["battle/attack_ready"] = {"battle/attackready", 0.2, true},
        ["battle/act_ready"]    = {"battle/actready", 0.2, true},
        ["battle/spell_ready"]  = {"battle/actready", 0.2, true},
        ["battle/item_ready"]   = {"battle/itemready", 0.2, true},
        ["battle/defend_ready"] = {"battle/defend", 1/15, false},

        ["battle/act_end"]      = {"battle/actend", 1/15, false, next="battle/idle"},

        ["battle/hurt"]         = {"battle/hurt", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]       = {"battle/defeat", 1/15, false},
        ["battle/swooned"]      = {"battle/defeat", 1/15, false},        

        ["battle/transition"]   = {"battle/transition", 0.2, true},
        ["battle/intro"]        = {"battle/attack", 1/15, false}, -- intro
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
        ["walk/left"] = {0, 0},
        ["walk/right"] = {0, 0},
        ["walk/up"] = {0, 0},
        ["walk/down"] = {0, 0},

        -- Battle offsets
        ["battle/idle"] = {-5, -1},

        ["battle/attack"] = {-3, 0}, -- can try "moving" attack forward then back via physics. not needed though
        ["battle/attackready"] = {-3, 0},
        ["battle/act"] = {-5, -1},
        ["battle/actend"] = {-5, -1},
        ["battle/actready"] = {-5, -1},
        ["battle/item"] = {-3, -1},
        ["battle/itemready"] = {-3, -1},
        ["battle/defend"] = {-5, -1},
        ["battle/swooned"] = {-8, -5},

        ["battle/defeat"] = {-8, -5},
        ["battle/hurt"] = {-5, -1},

        ["battle/intro"] = {-8, -9},
        ["battle/victory"] = {-3, 0},

    }
end


return actor