local BLJitterCharge, super = Class(Object)

function BLJitterCharge:init(count)
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    self.count_func = count

    self.press_count = 0
    self.state = "CHARGE"
end

function BLJitterCharge:onAdd(parent)
    Game.battle.timer:after(5, function()
        self.state = "STOP"
    end)
end

function BLJitterCharge:update()
    if Input.pressed("confirm") then
        self.press_count = self.press_count + 1
        Assets.stopAndPlaySound("yahoo", 0.8)
        Game.battle.timer:after(0.2, function()
            Assets.stopAndPlaySound("yahoo", 0.8)
        end)
          --Kristal.Console:log(Utils.dump(self.press_count))
    end

    if self.state == "STOP" then
        self.count_func(self.press_count)
        self:remove()
        return
    end
    super.update(self)
end

return BLJitterCharge
