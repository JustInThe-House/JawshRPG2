return {
    cornered = function(cutscene)
        local vinny = cutscene:getCharacter("vinny")
        local jawsh = cutscene:getCharacter("jawsh")
        local happyguy = cutscene:getCharacter("happyguy")
        cutscene:setSpeaker(happyguy)
        cutscene:text("* Aaaaaahh![wait:5] Help meeeee!")
        cutscene:detachCamera()
        local time_pan_1 = 1.5
        cutscene:panTo("cornered", time_pan_1)
        cutscene:wait(time_pan_1)
        cutscene:text("* Why are you doing this enderman?", { top = false })
        cutscene:text("* I thought you would be my frienderman!!", { top = false })
        cutscene:text("* Help![wait:5] Heeeeeeelp!", { top = false })
        cutscene:attachCamera(time_pan_1)
        cutscene:wait(time_pan_1)
        cutscene:setSpeaker()
        cutscene:text("* [speed:0.7]Aaaand[speed:1] he's already getting killed.", "neutral", "jawsh")
        cutscene:text("* Hang on a second![wait:5] We'll be right there!", "neutral", "jawsh")
        cutscene:wait(0.2)
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
