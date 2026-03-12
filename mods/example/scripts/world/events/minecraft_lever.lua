local MinecraftLever, super = Class(Event, "minecraft_lever")

function MinecraftLever:init(data)
    super.init(self, data.x, data.y)

    self.sprite = Sprite("world/events/lever")
    self:addChild(self.sprite)

    self:setSize(self.sprite:getSize())
    self:setHitbox(5, 10, 13, 40)

    self.flag = data.properties["flag"] 
    self.set_flag = data.properties["setflag"]
    self.set_value = data.properties["setvalue"]
    self.flag_req = data.properties["flagreq"]


    self.solid = true
end

function MinecraftLever:getDebugInfo()
    local info = super.getDebugInfo(self)
    table.insert(info, "Flipped: " .. (self:getFlag("flipped") and "True" or "False"))
    return info
end

function MinecraftLever:onAdd(parent)
    super.onAdd(self, parent)
    if self:getFlag("flipped") then
        self.sprite:setFrame(2)
    end
end

function MinecraftLever:onInteract(player, dir)
    if self:getFlag("flipped") then
        self.world:showText({
            "* It's already flipped down.",
        })
    elseif Game:getFlag(self.flag,0) ~= self.flag_req then
                Kristal.Console:log("hello??")

                self.world:showText({
            "* It won't budge.",
        })
    else
        Game:setFlag(self.set_flag, self.set_value)
        Assets.playSound("impact")
        self.sprite:setFrame(2)
        self:setFlag("flipped", true)
    end
    return true
end

return MinecraftLever