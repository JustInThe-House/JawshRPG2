return {
    hurb = function(cutscene)
        local px1, py1 = cutscene:getMarker("camera_pan_1")
        local starwalker = cutscene:getCharacter("starwalker")

        cutscene:detachCamera()
        cutscene:panTo(starwalker.x, starwalker.y, 0.25)
        cutscene:text("* You see that up there?")
        cutscene:wait(0.25)
        cutscene:panTo(px1, py1, 2)
        Game.world.timer:tween(2, Game.world.camera, { zoom_x = 0.75, zoom_y = 0.75 })
        cutscene:wait(4)
        cutscene:attachCamera(2)
        Game.world.timer:tween(2, Game.world.camera, { zoom_x = 1, zoom_y = 1 })
        cutscene:wait(2)
        cutscene:text("* Funny stuff.")
    end,
    gate = function(cutscene)
        if Game.inventory:getItemCount("schlattcoin") <= 4 then
            cutscene:text("* Please insert 5 Schlatt Coins to open this gate.")
        else
            cutscene:text("* You insert the Schlatt Coins.")
            Game:setFlag("minecraft_2_gate_open", true)
            Assets.playSound("locker")
            for i = 1, 5 do
                Game.inventory:removeItem("schlattcoin")
            end
            cutscene:wait(1)
        end
    end
}
