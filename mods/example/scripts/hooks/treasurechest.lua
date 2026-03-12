---@class TreasureChest : Event
---
---@field theme    string       *[Property 'theme']* The type of chest.
---@field scale    number       *[Property 'scale']* Scaling done to chest

local TreasureChest, super = HookSystem.hookScript(TreasureChest)

function TreasureChest:init(x, y, properties)
    super.super.init(self, x, y, properties)

    self.theme = properties["theme"] or ""
    -- i dont want to use a scale param, mainly because dont want overly complex chests. may not even add more. just leave as is

    self.sprite = Sprite("world/events/treasure_chest" .. self.theme)
    -- 20x20 is base sprite
    local width, height = self.sprite:getSize()
    self.x = self.x + math.max(0, width - 20) / 2
    self.y = self.y - math.max(0, height - 20)

    properties = properties or {}
    self:setOrigin(0.5, 0.5)
    self:setScale(2)

    self:addChild(self.sprite)

    self:setSize(width, height)


    self:setHitbox(0 + math.max(0, width - 20) / 2, 8 + math.max(0, height - 20), 20, 12)


    self.item = properties["item"]
    self.money = properties["money"]

    self.set_flag = properties["setflag"]
    self.set_value = properties["setvalue"]

    self.solid = true

    self.item_list = { "airbag", "basiccard", "blueribbon", "brokenwatch", "bullseye", "cloak", "delusionbrace",
        "dreammask", "ducttapedjeans", "dvdcase", "glassbrick", "heartcharm", "lincolnbust", "masterwatch", "metrognome",
        "oobleck", "overalls", "panicbutton", "pickelhaube", "shadowmantle", "silver_watch", "silvercoin", "skilltree",
        "stache"
        -- need to update this every so often
    }
end

function TreasureChest:onInteract(player, dir)
    if self:getFlag("opened") then
        self.world:showText("* (The chest is empty.)")
    else
        Assets.playSound("locker")
        self.sprite:setFrame(2)
        self:setFlag("opened", true)

        local name, success, result_text
        if self.item then
            local item = self.item
            if type(self.item) == "string" then
                if self.item == "random" then
                    item = Registry.createItem(TableUtils.pick(self.item_list))
                else
                    item = Registry.createItem(self.item)
                end
            end
            success, result_text = Game.inventory:tryGiveItem(item)
            name = item:getName()
        elseif self.money then
            name = self.money .. " " .. Game:getConfig("darkCurrency")
            success = true
            result_text = "* ([color:yellow]" ..
            name .. "[color:reset] was added to your [color:yellow]MONEY HOLE[color:reset].)"
            Game.money = Game.money + self.money
        end

        if name then
            self.world:showText({
                                    "* (You opened the treasure\nchest.)[wait:5]\n* (Inside was [color:yellow]" ..
                                    name .. "[color:reset].)",
                                    result_text
                                }, function()
                                    if not success then
                                        self.sprite:setFrame(1)
                                        self:setFlag("opened", false)
                                    end
                                end)
        else
            self.world:showText("* (The chest is empty.)")
            success = true
        end

        if success and self.set_flag then
            Game:setFlag(self.set_flag, (self.set_value == nil and true) or self.set_value)
        end
    end

    return true
end

return TreasureChest
