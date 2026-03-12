function Mod:init()
    print("Loaded "..self.info.name.."!")
    self.voice_timer = 0
        TableUtils.merge(MUSIC_VOLUMES, {
        ["arcade_battle"] = 1/0.7
    })
end

function Mod:postInit(new_file)
    HookSystem.hook(Utils, "map", function(orig, tbl, func)
        local result = {}
        for index, value in ipairs(tbl) do
            result[index] = func(value, index)
        end
        return result
    end)

    if new_file then
        Game.world:startCutscene("jawsh_house.intro")
    end
end

function Mod:getActionButtons(battler, buttons)
    return {"fight", "magic", "item", "defend"}
end

function Mod:preUpdate()
    self.voice_timer = MathUtils.approach(self.voice_timer, 0, DTMULT)
end