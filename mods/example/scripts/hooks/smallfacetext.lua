local SmallFaceText, super = HookSystem.hookScript(SmallFaceText)

function SmallFaceText:update()
    if self.alpha < 1 then
        self.alpha = MathUtils.approach(self.alpha, 1, 0.2*DTMULT)
    end
    if self.sprite and self.sprite.x > 0 then
        self.sprite.x = MathUtils.approach(self.sprite.x, 0, 10*DTMULT)
    end
    if self.text.x > 70 then
        self.text.x = MathUtils.approach(self.text.x, 70, 10*DTMULT)
    end

    if self.sprite.height > 64 then
        local scale_factor = math.ceil(self.sprite.height / 64)
        self.sprite:setScale(1 / scale_factor, 1 / scale_factor)
    else
        self.sprite:setScale(1, 1)
    end


    super.super.update(self)
end



return SmallFaceText
