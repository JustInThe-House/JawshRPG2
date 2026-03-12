local Lib = {}

--[[

This library serves to add support for shearing objects.

Changes:

-- Added shear_x and shear_y variables to the Object class
-- Added setShear & getShear
-- Added setShearOrigin & getShearOrigin
-- Added setShearOriginExact & getShearOriginExact

-- a.k.a. everything that rotation and scaling had
-- it's pretty self-explanatory to be honest
]]

function Lib:init()
	HookSystem.hook(Object, "init", function(orig, self, ...)
		orig(self, ...)
		
		self.shear_x = 0
		self.shear_y = 0
		
		--wait i dont even need to do this they're already nil
		--whatever
		self.shear_origin_x = nil
		self.shear_origin_y = nil
		self.shear_origin_exact = nil
	end)
	
	HookSystem.hook(Object, "setShear", function(orig, self, x, y)
		self.shear_x = x or 0; self.shear_y = y or 0
	end)
	
	HookSystem.hook(Object, "getShear", function(orig, self, x, y)
		return self.shear_x, self.shear_y
	end)
	
	HookSystem.hook(Object, "setShearOrigin", function(orig, self, x, y)
		self.shear_origin_x = x or 0; self.shear_origin_y = y or x or 0; self.shear_origin_exact = false
	end)

	HookSystem.hook(Object, "getShearOrigin", function(orig, self)
		if not self.shear_origin_exact then
			local ox, oy = self:getOrigin()
			return self.shear_origin_x or ox, self.shear_origin_y or oy
		else
			local ox, oy = self:getOriginExact()
			return (self.shear_origin_x or ox) / self.width, (self.shear_origin_y or oy) / self.height
		end
	end)

	HookSystem.hook(Object, "setShearOriginExact", function(orig, self, x, y)
		self.shear_origin_x = x or 0; self.shear_origin_y = y or x or 0; self.shear_origin_exact = true
	end)

	HookSystem.hook(Object, "getShearOriginExact", function(orig, self)
		if self.shear_origin_exact then
			local ox, oy = self:getOriginExact()
			return self.shear_origin_x or ox, self.shear_origin_y or oy
		else
			local ox, oy = self:getOrigin()
			return (self.shear_origin_x or ox) * self.width, (self.shear_origin_y or oy) * self.height
		end
	end)

	HookSystem.hook(Object, "applyTransformTo", function(orig, self, transform, floor_x, floor_y)
		Utils.pushPerformance("Object#applyTransformTo")
		if not floor_x then
			transform:translate(self.x, self.y)
		else
			transform:translate(MathUtils.floorToMultiple(self.x, floor_x), MathUtils.floorToMultiple(self.y, floor_y))
		end
		if self.parent and self.parent.camera and (self.parallax_x or self.parallax_y or self.parallax_origin_x or self.parallax_origin_y) then
			local px, py = self.parent.camera:getParallax(self.parallax_x or 1, self.parallax_y or 1, self.parallax_origin_x,
				self.parallax_origin_y)
			if not floor_x then
				transform:translate(px, py)
			else
				transform:translate(MathUtils.floorToMultiple(px, floor_x), MathUtils.floorToMultiple(py, floor_y))
			end
		end
		if self.flip_x or self.flip_y then
			transform:translate(self.width / 2, self.height / 2)
			transform:scale(self.flip_x and -1 or 1, self.flip_y and -1 or 1)
			transform:translate(-self.width / 2, -self.height / 2)
		end
		if floor_x then
			floor_x = floor_x / self.scale_x
			floor_y = floor_y / self.scale_y
		end
		local ox, oy = self:getOriginExact()
		if not floor_x then
			transform:translate(-ox, -oy)
		else
			transform:translate(-MathUtils.floorToMultiple(ox, floor_x), -MathUtils.floorToMultiple(oy, floor_y))
		end
		if self.rotation ~= 0 then
			local ox, oy = self:getRotationOriginExact()
			if floor_x then
				ox, oy = MathUtils.floorToMultiple(ox, floor_x), MathUtils.floorToMultiple(oy, floor_y)
			end
			transform:translate(ox, oy)
			transform:rotate(self.rotation)
			transform:translate(-ox, -oy)
		end
		if self.scale_x ~= 1 or self.scale_y ~= 1 then
			local ox, oy = self:getScaleOriginExact()
			if floor_x then
				ox, oy = MathUtils.floorToMultiple(ox, floor_x), MathUtils.floorToMultiple(oy, floor_y)
			end
			transform:translate(ox, oy)
			transform:scale(self.scale_x, self.scale_y)
			transform:translate(-ox, -oy)
		end
		if self.shear_x and (self.shear_x ~= 0 or self.shear_y ~= 0) then
			local ox, oy = self:getShearOriginExact()
			if floor_x then
				ox, oy = MathUtils.floorToMultiple(ox, floor_x), MathUtils.floorToMultiple(oy, floor_y)
			end
			transform:translate(ox, oy)
			transform:shear(self.shear_x, self.shear_y)
			transform:translate(-ox, -oy)
		end
		if self.camera then
			self.camera:applyTo(transform, floor_x, floor_y)
		end
		if self.graphics and ((self.graphics.shake_x and self.graphics.shake_x ~= 0) or (self.graphics.shake_y and self.graphics.shake_y ~= 0)) then
			local shake_x, shake_y = math.ceil(self.graphics.shake_x), math.ceil(self.graphics.shake_y)
			if not floor_x then
				transform:translate(shake_x, shake_y)
			else
				transform:translate(MathUtils.floorToMultiple(shake_x, floor_x), MathUtils.floorToMultiple(shake_y, floor_y))
			end
		end
		Utils.popPerformance()
	end)
	
end

return Lib