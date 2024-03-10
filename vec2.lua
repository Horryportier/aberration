local transfer_funcs = require("utils").transfer_funcs
---@class Vec2
---@field x number
---@field y number
Vec2 = {}

Vec2.mt = {
	__add = function(u, v)
		return Vec2.new(u.x + v.x, u.y + v.y)
	end,
	__sub = function(u, v)
		return Vec2.new(u.x - v.x, u.y - v.y)
	end,
	__mul = function(u, v)
		return Vec2.new(u.x * v.x, u.y * v.y)
	end,
	__div = function(u, v)
		return Vec2.new(u.x / v.y, v.y * v.y)
	end,

	__tostring = function(self)
		return string.format("Vec2 (%f, %f)", self.x, self.y)
	end,
}
Vec2.__type = function()
	return "vec2"
end

---@param x number
---@param y number?
---@return Vec2
function Vec2.new(x, y)
	local t = { x = x, y = y or x }
	transfer_funcs(t, Vec2)
	setmetatable(t, Vec2.mt)
	return t
end

Vec2.default = function()
	return Vec2.new(0, 0)
end

Vec2.get_xy = function(self)
	return self.x, self.y
end
Vec2.get_x = function(self)
	return self.x
end
Vec2.get_y = function(self)
	return self.y
end

Vec2.add = function(self, other)
	self = self + other
end
Vec2.sub = function(self, other)
	self = self - other
end

Vec2.mul = function(self, other)
	self = self * other
end

Vec2.normalize = function(self)
	local w = math.sqrt(self.x * self.x + self.y * self.y)
	if w ~= 0 then
		return Vec2.new(self.x / w, self.y / w)
	end
	return Vec2.new(self.x, self.y)
end

Vec2.as_array = function(self)
	return { self.x, self.y }
end

---@param self Vec2
---@return number
Vec2.to_angle = function(self)
	return math.atan2(-self.y, -self.x)
end

Vec2.clamp = function(self, min, max)
	self.x = self.x < min.x and min.x or self.x
	self.x = self.x > max.x and max.x or self.x
	self.y = self.y < min.y and min.y or self.y
	self.y = self.y > max.y and max.y or self.y
end

Vec2.ZERO = Vec2.default()
Vec2.UP = Vec2.new(0, -1)
Vec2.DOWN = Vec2.new(0, 1)
Vec2.LEFT = Vec2.new(-1, 0)
Vec2.RIGHT = Vec2.new(1, 0)

return Vec2
