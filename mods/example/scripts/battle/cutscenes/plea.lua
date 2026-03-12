return {
    plea1 = function (cutscene, battler, enemy)
        -- Open textbox and wait for completion
        cutscene:text("* Vinny tried speaking to the Jawsh...")
        cutscene:text("* Calm down Jawshy,[wait:5] we're your friends!", "pleased", "ralsei")
        cutscene:text("* If kino is destroyed, then,[wait:5] then...", "concern", "ralsei")
        cutscene:text("* What will happen to all the Adam Sandler movies??!?", "concern", "ralsei")
        cutscene:text("[wait:7]* Vinny's pleas were unheard.")
    end,
    plea2 = function (cutscene, battler, enemy)
        -- Open textbox and wait for completion
        cutscene:text("* Vinny tried again...")
        cutscene:text("[wait:5]* Please, stop this...", "concern", "ralsei")
        cutscene:text("[wait:7]* The Jawsh did not listen.")
    end
}
