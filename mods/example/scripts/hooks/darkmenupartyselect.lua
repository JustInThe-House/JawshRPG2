local DarkMenuPartySelect, super = HookSystem.hookScript(DarkMenuPartySelect)

function DarkMenuPartySelect:init(x, y, index)
    super.super.init(self, x, y)

    self.focused = false

    if index ~= nil then 
        self.selected_party = index
    else
        self.selected_party = 1
    end

    self.on_select = nil

    self.heart_siner = 0

    self.highlight_party = true
end

function DarkMenuPartySelect:draw()
    for i,party in ipairs(Game.party) do
        if self.selected_party ~= i then
            Draw.setColor(1, 1, 1, 0.4)
        else
            Draw.setColor(1, 1, 1, 1)
        end
        local ox, oy = party:getMenuIconOffset()
        Draw.draw(Assets.getTexture(party:getMenuIcon()), (i-1)*50 + (ox*2), oy*2, 0, 2, 2)
    end
    if self.focused then
        local frames = Assets.getFrames("player/heart_harrows")
        Draw.setColor(Game:getSoulColor())
        Draw.draw(frames[(math.floor(self.heart_siner/20)-1)%#frames+1], (self.selected_party-1)*50 + 10, -18,0,0.25,0.25)
    end
    super.super.draw(self)
end

return DarkMenuPartySelect