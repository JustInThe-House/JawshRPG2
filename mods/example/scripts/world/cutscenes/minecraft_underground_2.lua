return {
    meet = function(cutscene)
        -- markers: pan_vents, pan_happyguy, move_happyguy1, move_happyguy2, spawn


        local spawn_x, spawn_y = cutscene:getMarker("spawn")

        local vinny = cutscene:getCharacter("vinny")
        local jawsh = cutscene:getCharacter("jawsh")
        local happyguy = cutscene:getCharacter("happyguy")

        cutscene:detachCamera()
        cutscene:detachFollowers()
        local time_pan_1 = 2
        vinny:walkTo(spawn_x + 50, spawn_y, time_pan_1, "up")
        jawsh:walkTo(spawn_x - 50, spawn_y, time_pan_1, "up")
        cutscene:panTo("spawn", time_pan_1)

        cutscene:wait(time_pan_1)
        cutscene:text("* cough *[wait:5] * cough * ", "sad", "vinny")
        cutscene:text("* It got so much harder to see!", "sad", "vinny")
        cutscene:text("* And the air pollution down here is awful!", "sad", "vinny")

        jawsh:setSprite("walk/right")
        cutscene:text("* What could be causing this?", "neutral", "jawsh")
        local music_spot = Game.world.music:tell()
        Game.world.music:fade(0, 1)
        local mining = true
        local sound_time = 1.3
        Game.world.timer:doWhile(function ()
            return mining end, function ()
                sound_time = sound_time + DT
                if sound_time >= 1.3 then
                    sound_time = 0
                    Assets.playSound("minecraft/stone_mine", 1.5)
                end
            end)

        cutscene:wait(0.5)
        --minecraft mining sounds
        jawsh:setSprite("walk/up")
        cutscene:wait(0.5)

        cutscene:text("* Hello?[wait:5] Is someone there?", "neutral", "jawsh", { top = false })
        -- happy guy turns around (note, he is covered in smog)
        cutscene:wait(0.5)
        mining = false
        cutscene:wait(0.5)
        cutscene:text("* What?[wait:5] Is someone else here?", "neutral", "happyguy", { top = false })

        cutscene:panTo("pan_happyguy", 2.5)


        cutscene:text("* Wow![wait:5] New friends to meet!", "neutral", "happyguy", { top = false })
        cutscene:text("* Give me one second...", "neutral", "happyguy", { top = false })
        cutscene:wait(0.8)
        happyguy:spin(1)
        Game:setFlag("minecraft_smoke_airout", true)
        Assets.playSound("air_blast_long")
        cutscene:wait(1.8)
        happyguy:spin(0)
        cutscene:wait(1)
        Assets.playSound("happyguy_hello")
        cutscene:wait(0.5)
        happyguy:setAnimation({ "wave", 0.1, true })
        cutscene:wait(1.5)
        Game:setFlag("minecraft_smoke_airout", false)


        Game.world.music:play("hello_world")
        Game.world.music.volume = 1
        local time_pan_2 = 2
        local y_pan = 190
        cutscene:panTo(spawn_x, spawn_y - y_pan, time_pan_2)
        vinny:walkTo(vinny.x, vinny.y - 100, time_pan_2, "up")
        jawsh:resetSprite()
        jawsh:walkTo(jawsh.x, jawsh.y - 100, time_pan_2, "up")
        cutscene:wait(time_pan_2)
        cutscene:text("* Woah, it's the Minecraft the Musical guy!", "happy", "jawsh", { top = false })
        cutscene:wait(0.7)
        happyguy:resetSprite()
        cutscene:text("* What?[wait:5] Minecraft the Musical?[wait:5] What are you talking about?", "neutral", "happyguy",
                      { top = false })
        happyguy:setAnimation({ "wave", 0.1, true })
        cutscene:text("* IIIII'm[wait:3] Happy Guy!", "neutral", "happyguy", { top = false })

        happyguy:setSprite("walk/down")
        cutscene:text("* How did you guys get here? I thought I was the only one!", "neutral_forward", "happyguy", { top = false })
        cutscene:text("* Gasp! *[wait:7]   Are you The Player?", "neutral", "happyguy", { top = false })
        cutscene:text("* Uhh,[wait:10] yeah,[wait:2] sure,[wait:2] buddy.", "neutral", "jawsh",
                      { top = false })
        cutscene:text("* Listen,[wait:5] we're looking for a Mediashare fragment.", "neutral", "vinny", { top = false })
        cutscene:text("* Have you seen or heard anything about it?", "neutral", "vinny", { top = false })
        happyguy:setSprite("walk/down")

        cutscene:text("* Hmm,[wait:5] I'm not sure...", "neutral", "happyguy", { top = false })
        cutscene:text("* Oh! Yes! I did see something!", "neutral", "happyguy", { top = false })

        cutscene:text("* At the top of Kingdom Castle,[wait:5] I saw a weird floating shard.", "neutral", "happyguy",
                      { top = false })
        cutscene:text("* It looked a little scary, so I left it alone, but I was wondering what it was...", "neutral",
                      "happyguy",
                      { top = false })
        cutscene:text("* Great![wait:5] How do we get to this castle?", "happy", "vinny", { top = false })
        cutscene:text("* Well,[wait:5] it's the way on the right,[wait:5] but...", "neutral", "happyguy", { top = false })
        local time_pan_3 = 1.5
        cutscene:panTo("pan_vents", time_pan_3)
        happyguy:setSprite("walk/right")
        jawsh:setSprite("walk/right")
        vinny:setSprite("walk/right")


        cutscene:wait(1.5)
        cutscene:text("* The coal vents are on overdrive right now,[wait:5] probably from all of my mining.", "neutral",
                      "happyguy",
                      { top = false })
        cutscene:text("* If you step in that,[wait:5] you'll die of black lung before you can say,[wait:5]Hello!",
                      "neutral", "happyguy",
                      { top = false })

        cutscene:panTo(spawn_x, spawn_y - y_pan, time_pan_3)
        cutscene:wait(time_pan_3)

        happyguy:setSprite("walk/down")
        jawsh:setSprite("walk/up")
        vinny:setSprite("walk/up")
        cutscene:text("* You have to go a bit deeper to ventilate the mines.", "neutral", "happyguy", { top = false })
        happyguy:setAnimation({ "wave", 0.1, true })

        cutscene:text("* Luckily, I've worked in this place for years,[wait:5] so I can guide you through!", "neutral",
                      "happyguy",
                      { top = false })
        happyguy:resetSprite()
        happyguy:walkTo("move_happyguy1", 1.6, "down", true, "linear", function()
            jawsh:setSprite("walk/left")
        vinny:setSprite("walk/left")
            happyguy:walkTo("move_happyguy2", 2, "left", true, "linear", function()
                happyguy.y = happyguy.y + 300
                    happyguy.visible = false
            end)
        end)
        cutscene:text("* Follow me!", "neutral", "happyguy", { top = false })
        
        cutscene:wait(2)

        cutscene:text("* What if...[wait:5] we just let him do all the work?", "happy", "vinny", { top = false })
        jawsh:setSprite("walk/right")
        cutscene:text("* Nah, knowing that guy, he'll probably die in a minute.", "neutral", "jawsh", { top = false })
        cutscene:text("* Let's catch up to him.", "neutral", "jawsh", { top = false })

        Game.world.music:fade(0, 0.5)
        cutscene:attachCamera(0.5)
        jawsh:resetSprite()
        vinny:resetSprite()
        cutscene:alignFollowers()
        cutscene:attachFollowers()
        cutscene:wait(0.5)
        Game.world.music:play("mining_coal")
        Game.world.music:seek(music_spot)
        Game:setFlag("happyguy_meet", true)


        Game.world.music:fade(1, 1)
    end,
}
