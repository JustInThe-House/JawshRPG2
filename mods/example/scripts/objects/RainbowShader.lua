local RainbowShader, super = Class(Object, "RainbowShader")
-- this is free, not used ATM
function RainbowShader:init()
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) -- change w and h to sprite size
    --self.colorshader = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    self:setColor(1,1,1)
    self.alpha = 0.5
    self.siner = 0

end

function RainbowShader:update()
self.siner = self.siner + DTMULT
    local function fcolor(h, s, v)
        self.hue = (h / 255) % 1
        return Utils.hsvToRgb((h / 255) % 1, s / 255, v / 255)
    end
self:setColor(fcolor(self.siner / 4, 160 + (math.sin(self.siner / 32) * 60), 255))
    super.update(self)
end

return RainbowShader
