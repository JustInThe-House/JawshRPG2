return function(cutscene)
    local vinny = cutscene:getCharacter("vinny")
    local cuck_shed = Sprite("images/cuck_shed", vinny.x - SCREEN_WIDTH / 2, -50 + vinny.y - SCREEN_HEIGHT / 2)
    cuck_shed:setScale(0.9, 0.9)
    cuck_shed.layer = vinny.layer + 10
    Game.world:addChild(cuck_shed)
    cutscene:wait(3)
    cuck_shed:remove()
end