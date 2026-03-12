local ColorShadeArea, super = Class(Event, "colorshadearea")

function ColorShadeArea:init(data)
	super.init(self, data.x, data.y, data.width, data.height)
	self.inside = false
	self.shade = nil
	self.color_hex = data.properties["color"] or "#000000"
	self.alpha_target = data.properties["alpha"] or 0.5
	self.transition_speed = data.properties["transition_speed"] or 0.5

	self:setHitbox(0, 0, data.width, data.height)
end

function ColorShadeArea:onEnter(chara)
	if not self.inside and chara.actor == Game.world.player.actor then
		self.inside = true
		self.shade = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
		self.shade:setColor(ColorUtils.hexToRGB(self.color_hex))
		self.shade.alpha = 0
		self.shade:fadeTo(self.alpha_target, self.transition_speed)
		Game.stage:addChild(self.shade)
	end
end

function ColorShadeArea:onExit(chara)
	local precol = false
	if chara.actor == Game.world.player.actor then
		for k, v in ipairs(self.world.map:getEvents("colorshadearea")) do
			if v:collidesWith(chara) and v ~= self then
				precol = true
			end
		end
		if precol == false then
			self.shade:fadeOutAndRemove(self.transition_speed)
		end
		if self.inside then
			self.inside = false
		end
	end
end

return ColorShadeArea
