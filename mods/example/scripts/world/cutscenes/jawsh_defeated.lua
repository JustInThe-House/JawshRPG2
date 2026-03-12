return {
    wall = function(cutscene, event)
        local berd = cutscene:getCharacter("berd")
        local vinny = cutscene:getCharacter("vinny")
        local peter = cutscene:getCharacter("peter")
        
        if berd then
            cutscene:setSpeaker(berd)
            cutscene:text("* We,[wait:5] we...[wait:10] actually did it?", "smile")
            --tf2 nope sfx
            cutscene:text("* Urrgh, uugh...", "smile")
            cutscene:text("* Is this the end?", "smile")
            -- crush soyingjawsh with car (lancer squish, flatten via halving scale_y)
            cutscene:setSpeaker(peter)
            cutscene:text("* Oh my god guys,[wait:5] did you hear?", "smile")
            cutscene:text("* The McCrib is back!", "smile")
            cutscene:setSpeaker(vinny)
            cutscene:text("* No freaking way!", "smile")
            cutscene:setSpeaker(berd)
            cutscene:text("* We gotta get it now!", "smile")
            cutscene:setSpeaker(peter)
            cutscene:text("* Let's go,[wait:5] I'm driving a hot 103 miles per hour to peak!", "smile")
            -- drive off, freeze on flattened jawsh
            -- roll credits cutscene

        end
    end
}
