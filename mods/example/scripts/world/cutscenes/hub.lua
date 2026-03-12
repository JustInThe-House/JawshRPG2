return {
    first_enter = function(cutscene, event)
        local jawsh = cutscene:getCharacter("jawsh")
        local vinny = cutscene:getCharacter("vinny")

        cutscene:wait(1)
        jawsh:setFacing("right")
        cutscene:wait(0.5)
        jawsh:setFacing("left")
        cutscene:wait(0.5)
        jawsh:setFacing("right")
        cutscene:wait(0.5)
        jawsh:setFacing("left")
        cutscene:wait(0.5)
        jawsh:setFacing("down")
        cutscene:fadeOut(0, { music = true })

        -- may do a fade and show the entire hub area in the future. then fade back to jawsh

        cutscene:setSpeaker(jawsh)
        cutscene:text("* Wow,[wait:5] this place is surprisingly big!", "happy")
        cutscene:text("* But I'm seeing a weird theme.", "neutral")
        cutscene:text("* Because that's the Wacky Wheel...", "neutral")
        cutscene:text("* Because that's the Wacky Wheel...", "neutral")
        cutscene:text("* And up here...", "neutral")
        cutscene:text("* This is the spawn tree!", "neutral")
        cutscene:text("* It's like this world was made specifically for me...", "neutral")
        cutscene:text("* That's too parasocial for my taste.", "neutral")
        cutscene:text("* I'm getting out of here.", "neutral")

        cutscene:wait(2)
        cutscene:text("* ...[wait:5]I can't find the headset.", "neutral")
        cutscene:wait(2)
        cutscene:text("* Oh,[wait:5] come on already,[wait:5] just pull it off![wait:7] Grrrrah!", "mad")

        cutscene:text("* Get me out of this digital nightmare!", "mad")
        cutscene:wait(2)
        Game.world.music:pause()
        Assets.playSound("jawsh_vinny_jumpscare")
        cutscene:setSpeaker(vinny)
        cutscene:text("* JAWSH!", "idle",
                          { advance = true, auto = true })
                          cutscene:setSpeaker(jawsh)
        cutscene:text("* JAWSH!", "shocked")
        --vinnys theme plays
        --vinny walk down

        cutscene:wait(2)

        cutscene:text("* Oh.[wait:10] My.[wait:10] God.", "shocked")
        cutscene:text("* I almost had a heart attack.", "shocked")
        cutscene:text("* Guess I can still feel stuff in here.", "shocked")

        cutscene:setSpeaker(vinny)
        cutscene:text("* Yooooo,[wait:5] what's up Jawsh?", "happy")
        cutscene:text("* How", "happy")

        cutscene:setSpeaker(jawsh)
        cutscene:text("* Vinny,[wait:5] what are you doing here?", "neutral")

        cutscene:setSpeaker(vinny)
        cutscene:text("* Well, I was doing some,[wait:5], uh,[wait:5] \"other\" stuff in VR...", "neutral")
        cutscene:text("* But then I got transported here for whatever reason.", "neutral")

        cutscene:setSpeaker(jawsh)
        cutscene:text("* Can you take your headset off?", "neutral")

        cutscene:setSpeaker(vinny)
        cutscene:text("* What? Can I take my headset off?", "shocked")
        cutscene:text("* Of course I ca--", "neutral")
        --vinny disappears, then reappears
        cutscene:text("* See?", "neutral")

        cutscene:setSpeaker(jawsh)
        cutscene:text("* What the hell?", "neutral")
        cutscene:text("* Why can't I then?", "neutral")


        cutscene:setSpeaker(vinny)
        cutscene:text("* I think you've gotten a little TOO online,[wait:5] Jawsh.", "happy")

        cutscene:setSpeaker(jawsh)
        cutscene:text("* Shut up.", "mad")
        cutscene:text("* The point is,[wait:5] I'm stuck in here,[wait:5] and I need your help to get me out.", "neutral")
        cutscene:text("* Let's look around and find someone who can help us.", "neutral")
        -- add vinny to team
    end,
    transition = function(cutscene, event)
        local jawsh = cutscene:getCharacter("jawsh")

        local choice = cutscene:choicer({ "Go on X\n(Progress)", "Loaf Around" })
        if choice == 1 then
            local function spin()
                if jawsh.facing == "down" then
                    jawsh:setFacing("left")
                elseif jawsh.facing == "left" then
                    jawsh:setFacing("up")
                elseif jawsh.facing == "up" then
                    jawsh:setFacing("right")
                elseif jawsh.facing == "right" then
                    jawsh:setFacing("down")
                end
            end
            --[[cutscene:wait(3)
            cutscene:text("* Aaaand[wait:5] X is making me feel even worse.", "some_portrait_idk", "jawsh")
            cutscene:text("* I love seeing beheadings in my feed.", "some_portrait_idk", "jawsh")
            cutscene:wait(1)
            cutscene:text("* ...wait,[wait:5] Toby Fox is trending?", "some_portrait_idk", "jawsh")
            cutscene:text("* ...[wait:7]...[wait:7]he made another game?", "some_portrait_idk", "jawsh")
            cutscene:text("* That's stupid and it's going to suck.", "some_portrait_idk", "jawsh")
            cutscene:wait(2)
            cutscene:text("* ...[wait:5]hold on,[wait:5] this is a perfect opportunity!", "some_portrait_idk", "jawsh")
            cutscene:text("* If I can get my opinion on this game out first...", "some_portrait_idk", "jawsh")
            cutscene:text("* ...then I'll be famous on X and get a bunch of supporters!", "some_portrait_idk", "jawsh")
            cutscene:text("* Bloody brilliant!", "some_portrait_idk", "jawsh")
            cutscene:text("* Let's see what this game is about...", "some_portrait_idk", "jawsh")
            cutscene:wait(2)
            cutscene:text("* ...[wait:5]It's in VR???", "some_portrait_idk", "jawsh")
            cutscene:text("* Didn't know you could do pixel art in VR...", "some_portrait_idk", "jawsh")
            cutscene:wait(2)]]
            cutscene:text("* Well,[wait:5] I guess its time to bust this thing out.", "some_portrait_idk", "jawsh")
            -- pulls vr headset from desk, blows off dust
            cutscene:wait(0.3)
            Assets.playSound("noise")
            -- VR headset appears on desk, or sprite with headset on
            cutscene:wait(0.5)

            cutscene:text("* I never expected to have to use this again,[wait:5] especially after FNAF VR...",
                          "some_portrait_idk", "jawsh")
            cutscene:wait(1)
            cutscene:text("* Here goes...", "some_portrait_idk", "jawsh")
            cutscene:text("insert sprite with VR headset on", "some_portrait_idk", "jawsh")


            -- puts on, pause
            local layer_reset = jawsh.layer
            local bg_fade = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

            bg_fade:setColor(0, 0, 0)
            bg_fade.alpha = 0
            bg_fade.layer = WORLD_LAYERS["ui"]
            Game.world:addChild(bg_fade)
            Game.world.timer:tween(1.5, bg_fade, { alpha = 1 })
            cutscene:wait(1.5)
            jawsh.alpha = 0
            jawsh.layer = bg_fade.layer + 1
            local colormask = jawsh:addFX(ColorMaskFX({ 1, 1, 1 }, 0))
            Game.world.timer:tween(4, jawsh, { alpha = 1 })
            Game.world.timer:tween(4, colormask, { amount = 1 })
            cutscene:wait(1)
            jawsh.spin_speed = 4
            Game.world.timer:tween(4, jawsh, { spin_speed = 0.5 })
            cutscene:wait(5)
            jawsh:setActor("jawsh")
            Game.world.timer:tween(4, colormask, { amount = 0 })
            Game.world.timer:tween(3, jawsh, { spin_speed = 6 })
            cutscene:wait(3)
            jawsh.spin_speed = 0
            local spin_fix = 0
            if jawsh.facing == "left" then
                spin_fix = 3
            elseif jawsh.facing == "up" then
                spin_fix = 2
            elseif jawsh.facing == "right" then
                spin_fix = 1
            end
            Game.world.timer:every(0.5, function() spin() end, spin_fix)

            cutscene:wait(2.5)
            Game.world.timer:tween(0.5, jawsh, { alpha = 0 })
            cutscene:wait(0.5)
            jawsh.layer = layer_reset
            Game.world.timer:tween(1, bg_fade, { alpha = 0 }, "linear", function()
                bg_fade:remove()
            end)
            Game.world.timer:tween(0.5, jawsh, { alpha = 1 })


            jawsh:removeFX(colormask)
            -- turns into jawsh orange, spinning slowly stops
            cutscene:text("* They turned me into an orange.", "neutral", "jawsh")
            Game:setFlag("can_leave_home", true)
            cutscene:text("* Cool.", "happy", "jawsh")
            cutscene:text("* Let's go find what's bad about this game so I can complain about it.", "happy", "jawsh")
            cutscene:text(
                "[wait:5](This game controls like Deltarune. If you don't know that,[wait:5]\nthen you're already screwed.)")
        else
            cutscene:text("* You continue to loaf.")
        end
    end
    -- secretlab verticalmount to hold 4 monitors. 3rd monitor
    --soundproofing blankets currently. wants soundproof panels
    -- blueberry pie
    -- gooseberry pie

}
