local transfer_funcs = require("utils").transfer_funcs
---@class Color
---@field r number
---@field g number
---@field b number
---@field a number
---@field default function
---@field new function
Color = {}

Color.mt = {
	__tostring = function(self)
		return string.format("Color (%d, %d %d, %d)", self.r, self.g, self.b, self.a)
	end,
}

function Color.new(r, g, b, a)
	local t = { r = r, g = g or r, b = b or r, a = a or 1 }
	transfer_funcs(t, Color)
	setmetatable(t, Color.mt)
	return t
end

Color.default = function()
	return Color.new(0)
end

---@param self Color
---@return Color
Color.normalize = function(self)
	local r, g, b, a = self:unpack()
	return Color.new(r / 255, g / 255, b / 255, a)
end

Color.as_array = function(self)
	return { self.r, self.g, self.b, self.a }
end

Color.unpack = function(self)
	return self.r, self.g, self.b, self.a
end

Color.set = function(self, fn)
	fn(self.r, self.g, self.b, self.a)
end

return Color
