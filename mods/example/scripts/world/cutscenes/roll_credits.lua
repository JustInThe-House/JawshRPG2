return function(cutscene)
    
    cutscene:fadeIn(0)
    local objects = {} --- @type Text[]
 --   Game.world.music:setLooping(false)
   -- if Game.world.music.current ~= "credits" then Game.world.music:play("credits") end
    local function txt(str, x, y)
        local textobj = Text(str,(x or 0) + (SCREEN_WIDTH/2),y, {auto_size = true})
        textobj:setOrigin(0.5, 0)
        table.insert(objects, textobj)
        Game.stage:addChild(textobj)
        return textobj
    end
    local function clear()
        for _, textobj in ipairs(objects) do textobj:remove() end
        objects = {}
    end
    --[[local function mwait(t)
        cutscene:wait(function () return (not Game.world.music:isPlaying()) or (Game.world.music:tell() > (t * (80/60))) end)
    end]]

    txt("Jawsh RPG 2", 0, 20):setScale(2)
    txt("A Demo", 0, 80):setScale(1.5)
    txt("Made in Kristal", 0, 120)
cutscene:wait(4) clear()
    txt("Coding", 0, 20):setScale(1.5)
    txt("JustInTheHouse", 0, 80)
cutscene:wait(4) clear()
    txt("Artists", 0, 20):setScale(1.5)
    txt("JustInTheHouse\nSwaglexoid\nRalsei\nDeer", 0, 80)
cutscene:wait(4) clear()
    txt("Music", 0, 20):setScale(1.5)
    txt("danfm\nJustInTheHouse", 0, 80)
cutscene:wait(4) clear()
    txt("Other Thanks", 0, 20):setScale(1.5)
    txt("Kristal Dev Team\nMusic2 library by Dobby233Liu\nMIDI by SixtyTunes\nFreakin Jawsh, Vinny, and Berd!!!", 0, 80)
cutscene:wait(4) clear()
    txt("Fin.", 0, 120):setScale(2)
cutscene:wait(6); Game.state = "EXIT"; Game.fader:fadeOut(Kristal.returnToMenu)
  --  mwait(math.huge); cutscene:wait(1); Game.state = "EXIT"; Game.fader:fadeOut(Kristal.returnToMenu)
end
