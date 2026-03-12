local rpstudios_intro, super = Class(Video, "rpstudios_intro")

function rpstudios_intro:init(x, y, dir)
    -- Last argument = sprite path
    super.init(self, "videos/rpstudios_intro", x, y)
end


return rpstudios_intro