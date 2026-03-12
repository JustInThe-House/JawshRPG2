return {
    intro = function(cutscene, event)
        cutscene:fadeOut(0, { music = true })
        local jawsh = cutscene:getCharacter("jawsh")
        jawsh:setFacing("right")
        local mx1, my1 = cutscene:getMarker("stand_up")
        jawsh.rotation = -math.pi / 2
        local layer_reset = jawsh.layer
        jawsh.layer = WORLD_LAYERS["ui"]

        cutscene:wait(1)
        cutscene:fadeIn(2, { music = true })
        cutscene:wait(2)
        --[[cutscene:text("* Ah!", "some_portrait_idk", "jawsh")
        cutscene:wait(3)
        cutscene:text("* ...[wait:5]That was a weird dream...", "some_portrait_idk", "jawsh")
        cutscene:wait(2)
        cutscene:text("* Meh,[wait:5] probably didn't mean anything.", "some_portrait_idk", "jawsh")
        cutscene:wait(1)
        cutscene:text("* Ugh,[wait:5] what am I gonna do...", "some_portrait_idk", "jawsh")
        cutscene:text("* How am I gonna make this year the year of Jawsh...", "some_portrait_idk", "jawsh")
        cutscene:wait(1)
        cutscene:text("* Maybe X the everything app will give me some inspiration.", "some_portrait_idk", "jawsh")]]
        jawsh:setFacing("down")
        Game.world.timer:tween(0.5, jawsh, { rotation = 0, x = mx1, y = my1 })
        cutscene:wait(1)
        jawsh.layer = layer_reset
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
            -- look at deltarune for side desk examples
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
