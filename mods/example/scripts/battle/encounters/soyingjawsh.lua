local Dummy, super = Class(Encounter)

function Dummy:init()
    super.init(self)
    self.difficulty = 0
    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "The Soying Jawsh appeared."
    -- add something based on how many times you died
    -- self.text = "You thought of Mario to cope with this."

    -- Battle music ("battle" is rude buster)
    self.music = "violet_heartbeat"
    -- Enables the purple grid battle background
    self.background = true

    self:addEnemy("soyingjawsh", 522, 270)

    --- Uncomment this line to add another!
    --  self:addEnemy("dummy")
end

function Dummy:isAutoHealingEnabled(battler)
    return false
end

function Dummy:canSwoon(target)
    return true
end

function Dummy:getPartyPosition(index)
    --[[local x, y = 0, 0
    if #Game.battle.party == 1 then
        x = 80
        y = 140
    elseif #Game.battle.party == 2 then
        x = 180
        y = 100 + (80 * (index - 1))
    elseif #Game.battle.party == 3 then
        x = 80
        y = 50 + (80 * (index - 1))
    end

    local battler = Game.battle.party[index]
    local ox, oy = battler.chara:getBattleOffset()
    x = x + (battler.actor:getWidth() / 2 + ox) * 2
    y = y + (battler.actor:getHeight() + oy) * 2
    return x, y]]

    local positions = { { 140, 170 }, { 110, 240 }, { 60, 320 } } -- 3rd doesnt really matter
    return TableUtils.unpack(positions[index])
end

function Dummy:getDialogueCutscene()
    return function(cutscene)
        -- including setSpeaker(berd) means i dont have to put berd in the text one.
        if Game.battle.turn_count == 1 then
            cutscene:battlerText("berd", "Heh,[wait:5] didn't...[wait:7]\nthink we'd be still\nstanding,[wait:5] huh?", { x= 155, y = 170, right = true })
            cutscene:battlerText("berd", "But the fact is,[wait:5]\nyou messed up,[wait:5]\nmessing with us!", { x= 155, y = 170, right = true })
            cutscene:battlerText("berd", "You're all bitter and alone,[wait:5]\nwhile we,[wait:5] we've got each other!", { x= 155, y = 170, right = true })
            cutscene:battlerText("berd", "No matter what you do,[wait:5]", { x= 155, y = 170, right = true })
            cutscene:battlerText("berd", "No matter how many times you\nknock us down...", { x= 155, y = 170, right = true })
            cutscene:battlerText("berd", "As long as we're still here,\nthere's nothing you can do.", { x= 155, y = 170, right = true })

            cutscene:battlerText("berd", "So give it up.[wait:7] Ya done.", { x= 155, y = 170, right = true })
            cutscene:battlerText("berd", "Mediashare can't last forever,[wait:5]\nso...[wait:7] give up!", { x= 155, y = 170, right = true })

                        cutscene:battlerText("berd", "Still not gonna say a damn thing,[wait:5]\nhuh...,", { x= 155, y = 170, right = true })
                        cutscene:battlerText("berd", "...", { x= 155, y = 170, right = true })



        elseif Game.battle.turn_count == 14 then
            cutscene:battlerText("berd", "I can't believe what\nSMPLIVE did to you.", { x = 145, y = 170, right = true })
            cutscene:battlerText("berd", "I'm done talking.", { x = 145, y = 170, right = true })
        end

        -- these are the base ones, i guess
        --[[   cutscene:text("Obama???", "idle", "pyro")
                cutscene:text("Obama???", "angry", "berd")
                cutscene:text("Obama???", "idle", "pyro")
                cutscene:text("Obama???", "angry", "berd")
                cutscene:battlerText("vinny", "erm awkward", {x=140,y=162,right = true}) --wait=false
                cutscene:battlerText("vinny", "erm awkward", {x=135,y=83,right = true})
                cutscene:battlerText("vinny", "erm awkward", {x=130,y=243,right = true})]]
    end
end

return Dummy
