return {
    wall = function(cutscene, event)
        local kino = cutscene:getCharacter("kino")
        local pyro = cutscene:getCharacter("pyro")
        local vinny = cutscene:getCharacter("vinny")
        local jawsh = cutscene:getCharacter("jawsh")
        local mx, my = cutscene:getMarker("cutscene_pyro")
        local px1, py1 = cutscene:getMarker("camera_pan_1")

        pyro.layer = pyro.layer + 2
        cutscene:detachFollowers()
        cutscene:detachCamera()
        cutscene:walkTo(jawsh, mx, my - 80, 0.7, "right", true)
        cutscene:walkTo(vinny, mx, my + 80, 0.7, "right", true)
        cutscene:panTo(px1, py1, 1.3)
        cutscene:wait(1.3)
        Game.world.music:play("tv_hall_of_fame")


        if not Game:getFlag("saw_pyro_die", false) then
            cutscene:setSpeaker(pyro)
            cutscene:text("* Chat,[wait:5] would you please\nstand up and clap for our winners!!", "idle")
            cutscene:text("* For outstanding rizz and runk,[wait:5]the Streamers have won...", "idle")
            local tractor_beam = tractor_beam(pyro.x - 300, pyro.y - 100)
            tractor_beam.layer = pyro.layer
            Game.world:addChild(tractor_beam)


            -- cutscene:text("* The [image:emotes/grand_prize,0,0,2,2] !!!!", "idle")
            local grand_prize = Game.stage:addChild(grand_prize(397, 355))
            cutscene:text("* The                  !!!", "idle")
            grand_prize:remove()
            cutscene:panTo(px1, py1 - 300, 2)
            cutscene:wait(2.5)
            Game.world.timer:tween(0.5, kino, { y = kino.y - 50 }, "in-out-back")
            cutscene:wait(0.75)
            Game.world.timer:tween(2.5, kino, { y = kino.y + 250 })
            cutscene:panTo(px1, py1, 3)
            cutscene:wait(3.5)
            cutscene:text("* Here you go!![wait:5] He's all yours,[wait:5] kiddos!!", "idle")
            pyro:setSprite("aww")
            cutscene:wait(1)
            cutscene:text("* How wonderful!![wait:5] The gang's all here!!", "idle")
            pyro:setSprite("hooray")
            cutscene:text("* [speed:0.5]Now all of you can finally be friends with cmc-", "idle",
                          { advance = true, auto = true })
            Game.world.music:fade(0, 60 / 30, function()
                Game.world.music:stop()
            end)
            --local slash = slash_long(mx, my-100) -- need to add
            local slash = Sprite("attacks/slash_long/slash_long", mx + 360, my - 20)
            slash:setScale(2, 2)
            slash.flip_x = true
            slash.rotation = slash.rotation - math.pi / 2
            slash.layer = pyro.layer + 1
            slash:play(0.05, false, function() end)

            Game.world:addChild(slash)
            local bg_fade = Rectangle(px1 - SCREEN_WIDTH / 2, -60 + py1 - SCREEN_HEIGHT / 2, SCREEN_WIDTH, SCREEN_HEIGHT)
            bg_fade:setColor(0, 0, 0)
            bg_fade.layer = pyro.layer - 1
            Game.world:addChild(bg_fade)
            local colormask = pyro:addFX(ColorMaskFX())
            cutscene:wait(2)
            slash:remove()
            pyro:removeFX(colormask)
            pyro:remove()
            bg_fade:setColor(0.8, 0, 0.8, 0)
            cutscene:wait(3)
            cutscene:text("* RIPBOZO", "smile", "jawsh")
            cutscene:wait(0.5)
            Game.world.timer:tween(2, bg_fade, { alpha = 0.2 })
            Game.world.music:play("soyingjawsh_appears", 1)
            kino:shake(4, 4, 0.1)
            cutscene:wait(2)
            Game.world.timer:tween(1.5, kino, {
                                       x = kino.x + 700,
                                       y = kino.y + 80,
                                       rotation = kino.rotation + 4 * math
                                           .pi
                                   }, "out-quad")
            cutscene:wait(2)
            cutscene:text("* What the shit.[wait:3].[wait:3].[wait:3]?", "smile", "jawsh")
            Game:setFlag("saw_pyro_die", true)
            --    local tractor_beam = tractor_beam(mx,my)
            --  Game.world:addChild(tractor_beam)

            cutscene:wait(1)
        else
            cutscene:setSpeaker(pyro)
            pyro:setSprite("hooray")
            cutscene:text("* [speed:0.5]cmc7", "idle", { advance = true, auto = true })
        end


        cutscene:startEncounter("soyingjawsh")
        cutscene:attachCamera()
        cutscene:alignFollowers()
        cutscene:attachFollowers()
    end
}
