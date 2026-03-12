local Inventory, super = HookSystem.hookScript(Inventory)

function Inventory:getItemCount(item)
    local count = 0
    if type(item) == "string" then
        for k,v in pairs(self.stored_items) do
            if k.id == item then
                count = count + 1
            end
        end
        return count
    end
end

return Inventory