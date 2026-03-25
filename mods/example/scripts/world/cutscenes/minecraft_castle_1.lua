return {
    push = function(cutscene)
        local king = cutscene:getCharacter("king")
        cutscene:setSpeaker(king)
        cutscene:text("* [speed:0.7]Ahhh,[wait:5] the wind feels so nice up here.")
        local choice = cutscene:choicer({ "Push", "Don't        " })
        if choice == 1 then
            local push_time = 0.6
            Assets.playSound("whip_throw_only")
            king:slideTo(king.x + 65, king.y, push_time)
            cutscene:wait(push_time)
            local song_time = 20.5

            local music_spot = Game.world.music:tell()
            Game.world.music:play("fallen_kingdom")
            local sprite_extra_offset = 20
            local jawsho7 = Sprite("emotes/jawsho7", SCREEN_WIDTH+211+sprite_extra_offset, SCREEN_HEIGHT / 3)
            local vsg7 = Sprite("emotes/vsg7", 0-159*2.5-sprite_extra_offset, 0)
            jawsho7.alpha = 0.3
            vsg7.alpha = 0.3
            jawsho7:setScale(2)
            vsg7:setScale(2.5)
            jawsho7.physics.speed = -1.5
            vsg7.physics.speed = 1.5
            jawsho7.flip_x = true
            Game.stage:addChild(jawsho7)
            Game.stage:addChild(vsg7)
            

            king:setSprite("falling")

            king:slideTo(king.x, king.y + 300, song_time)
            cutscene:wait(song_time)
            king.visible = false
            jawsho7:fadeOutAndRemove(2)
            vsg7:fadeOutAndRemove(2)
            Game.world.music.volume = 0
            Game.world.music:play("stal")
            Game.world.music:seek(music_spot)
            Game.world.music:fade(1, 2)
            Game:setFlag("push_king",true)
        end
    end,
    fight = function(cutscene)
        local dropdown_x, dropdown_y = cutscene:getMarker("dropdown")


        local vinny = cutscene:getCharacter("vinny")
        local jawsh = cutscene:getCharacter("jawsh")
        local happyguy = cutscene:getCharacter("happyguy")
        local enderman1 = cutscene:getCharacter("enderman", 1)
        local enderman2 = cutscene:getCharacter("enderman", 2)



        cutscene:detachFollowers()
        cutscene:detachCamera()

        jawsh:setSprite("walk/up")
        local time_pan_1 = 0.7
        vinny:walkTo(dropdown_x + 20, dropdown_y + 60, time_pan_1, "up")
        jawsh:walkTo(dropdown_x - 20, dropdown_y + 60, time_pan_1, "up")
        cutscene:panTo(dropdown_x, dropdown_y - 10, time_pan_1)
        cutscene:wait(time_pan_1)

        cutscene:setSpeaker(happyguy)
        cutscene:text("* Please,[wait:5] guys![wait:5] Help me out!", { top = false })
        cutscene:wait(0.2)
        cutscene:startEncounter("enderman_2", true, { { "enderman:1", enderman1 }, { "enderman:2", enderman2 } })
        Game:setFlag("fought_endermen", true)


        cutscene:text("* Hooray![wait:5] You saved me!")
        cutscene:setSpeaker(jawsh)

        cutscene:text("* Look man,[wait:5] you're clearly not cut out for fighting down here.", "neutral")

        cutscene:text("* Why don't you just join our party and--", "happy",
                      { advance = true, auto = true })
        cutscene:setSpeaker(happyguy)
        local time_2 = 0.5
        Assets.playSound("jump", 1, 1)
        happyguy:jumpTo("dropdown", 4, time_2)

        cutscene:wait(time_2)


        happyguy:setFacing("right")

        cutscene:text("* Anyways,[wait:5] if you hit that lever,[wait:5] you'll shut off the smoke stacks.",
                      { top = false })

        cutscene:text("* I'll head back so we can clear it out faster!", { top = false })
        happyguy:setFacing("down")
        happyguy:resetSprite()

        happyguy:walkTo("move_happyguy1", 1.4, "down", true, "linear", function()
            happyguy.x = happyguy.x + 200
            happyguy.visible = false
        end)
        cutscene:wait(0.5)
        cutscene:setSpeaker(jawsh)
        cutscene:text("* No,[wait:3] no,[wait:3] no,[wait:3] just hold on a second and we can--", "mad", { top = false })
        --[[cutscene:wait(0.5)
        jawsh:setSprite("walk/right")
        cutscene:wait(0.2)
        jawsh:setSprite("walk/down")]]
        cutscene:wait(1)
        cutscene:text("* Siiiiiiiiigh...", "neutral", { top = false })
        cutscene:text("* Let's get this done quick so he doesn't kill himself.", "neutral", { top = false })
        jawsh:resetSprite()
        vinny:resetSprite()
        cutscene:alignFollowers()
        cutscene:attachFollowers()
        cutscene:attachCamera(0.5)
        cutscene:wait(0.5)
    end,
}
