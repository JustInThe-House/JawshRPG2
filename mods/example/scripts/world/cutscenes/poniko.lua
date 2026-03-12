return function(cutscene)
    Assets.playSound("noise")
    if math.random(0,1) == 1 then
       -- cutscene:text("* Funny stuff.")
    Game:setFlag("poniko_dark", "true")   
        Game.world.music:play("poniko_off")
    else
        Game:setFlag("poniko_scary", "true") 
    Game.fader:transition(nil, nil, {speed = 0.04, color = COLORS.white})
    end
    Game:setFlag("poniko_flicker", "true")
end