-- removes menu access in light world. youre in there for like 3 minutes, so its fine
---@class World : Object
---@field party_index         number    what party member the equip menu should return to after a cutscene
---@field item_index         number    what item the equip menu should return to after a cutscene

local World, super = HookSystem.hookScript(World)

function World:init(...)
    super.init(self,...)
    self.party_index = 1
    self.item_index = 1
end

function World:onKeyPressed(key)
    if Kristal.Config["debug"] and Input.ctrl() then
        if key == "m" then
            if self.music then
                if self.music:isPlaying() then
                    self.music:pause()
                else
                    self.music:resume()
                end
            end
        end
        if key == "s" then
            local save_pos = nil
            if Input.shift() then
                save_pos = {self.player.x, self.player.y}
            end
            if Game:getConfig("smallSaveMenu") then
                self:openMenu(SimpleSaveMenu(Game.save_id, save_pos))
            elseif Game:isLight() then
                self:openMenu(LightSaveMenu(save_pos))
            else
                self:openMenu(SaveMenu(save_pos))
            end
        end
        if key == "h" then
            for _,party in ipairs(Game.party) do
                party:heal(math.huge)
            end
        end
        if key == "b" then
            Game.world:hurtParty(math.huge)
        end
        if key == "k" then
            Game:setTension(Game:getMaxTension() * 2, true)
        end
        if key == "n" then
            NOCLIP = not NOCLIP
        end
    end

    if Game.lock_movement then return end

    if self.state == "GAMEPLAY" then
        if Input.isConfirm(key) and self.player and not self:hasCutscene() then
            if self.player:interact() then
                Input.clear("confirm")
            end
        elseif Input.isMenu(key) and not self:hasCutscene() and not Game:isLight() then
            self:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Input.clear("menu")
        end
    elseif self.state == "MENU" then
        if self.menu and self.menu.onKeyPressed then
            self.menu:onKeyPressed(key)
        end
    end
end

return World
