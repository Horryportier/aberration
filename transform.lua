local transfer_funcs = require("utils").transfer_funcs
local Vec2 = require("vec2")
local inspect = require("inspect").inspect
---@class Transform
---@field translation Vec2
---@field rotation number
---@field scale Vec2
---@field offset Vec2
local Transform = {}

Transform.mt = {
	__tostring = function(self)
		return string.format(
			[[
Transform ((T %s)
(R %s) 
(S %s)
(O %s))
]],
			self.translation,
			self.rotation,
			self.scale,
			self.offset
		)
	end,
}

Transform.get = function(self)
	return self.translation, self.rotation, self.scale, self.offset
end
Transform.set = function(self, translation, rotation, scale, offset)
	self.translation = translation
	self.rotation = rotation
	self.scale = scale
	self.offset = offset
end

---comment
---@param translation Vec2?
---@param rotation number?
---@param scale Vec2?
---@param offset Vec2?
---@return Transform
Transform.new = function(translation, rotation, scale, offset)
	return transfer_funcs(
		setmetatable({
			translation = translation or Vec2.default(),
			rotation = rotation or 0,
			scale = scale or Vec2.new(1, 1),
			offset = offset or Vec2.default(),
		}, Transform.mt),
		Transform
	)
end

---comment
---@return Transform
Transform.default = function()
	return Transform.new()
end

return Transform
