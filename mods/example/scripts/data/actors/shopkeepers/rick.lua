local actor, super = Class(Actor, "shopkeepers/rick")

function actor:init()
    super.init(self)

    self.name = "Rick"

    self.width = 384
    self.height = 240
    self.path = "shopkeepers/rick"
    self.default = "idle"

    self.animations = {
        -- Movement animations
        ["idle"] = {"idle", 4/30, true},
        ["lesson"] = {"lesson", 4/30, true},
        ["point"] = {"point", 4/30, true},
        ["treasure"] = {"treasure", 4/30, true},
    }

    self.talk_sprites = {}

    self.offsets = {}
end

return actor