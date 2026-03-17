local Map, super = Class(Map)

function Map:onEnter()
  self.arcadeshader = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
  self.arcadeshader.alpha = 0.2
  Game.stage:addChild(self.arcadeshader)
  self.siner = 0
end

function Map:update()
self.siner = self.siner + DTMULT*7
    local function fcolor(h, s, v)
        self.hue = (h / 255) % 1
        return Utils.hsvToRgb((h / 255) % 1, s / 255, v / 255)
    end
self.arcadeshader:setColor(fcolor(self.siner / 4, 160 + (math.sin(self.siner / 32) * 60), 255))
end

function Map:onExit()
  self.arcadeshader:remove()
end


return Map