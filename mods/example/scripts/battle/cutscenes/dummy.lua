return {
    threaten = function(cutscene, battler, enemy)
        -- Open textbox and wait for completion
        cutscene:text("* Susie confronted the Jawsh!")
        cutscene:text("* I don't know who or what you are...", "angry_b", "berd")
        cutscene:text("* But stay away from kino! [wait:5]You got that?", "angry_c", "berd")
        cutscene:text("* ...", "bangs_neutral", "berd")
        cutscene:text("* ...[wait:3]Not gonna listen, huh... ", "bangs_neutral", "berd")
        cutscene:text("* I'll make you regret that.", "bangs_teeth", "berd")
        cutscene:text("[wait:5]* Berd will not ACT any further.")
    end
}