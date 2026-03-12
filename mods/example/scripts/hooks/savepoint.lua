---@class Savepoint : Interactable
---@field healed  boolean   makes it so save points only heal you once
---@
local Savepoint, super = HookSystem.hookScript(Savepoint)

function Savepoint:init(...)
    super.init(self,...)
    self.healed = false
end

function Savepoint:onTextEnd()
    if not self.world then return end

    if self.heals and not self.healed then
        for _,party in pairs(Game.party_data) do
            party:heal(math.huge, false)
        end
        --self.healed = true readd if want one heal only
    end
    Input.clear("confirm")
    if Game:isLight() then
        self.world:openMenu(LightSaveMenu(Game.save_id, self.marker))
    elseif self.simple_menu or (self.simple_menu == nil and Game:getConfig("smallSaveMenu")) then
        self.world:openMenu(SimpleSaveMenu(Game.save_id, self.marker))
    else
        self.world:openMenu(SaveMenu(self.marker))
    end
end



return Savepoint