return {
    stacker = function(cutscene, event, chara)
    if chara.facing == "up" then
        local choice = cutscene:choicer({ "Play Stacker", "Nah        " })
if choice == 1 then
    cutscene:startEncounter("stacker_machine", true)
end
else
    cutscene:text("* You need to see the screen to play.")
end
    end,
}
