local Transform = require("transform")
local inspect = require("inspect").inspect
local utils = require("utils")

local Camera = {
	t = Transform.default(),
}

Camera.update = function(self)
	love.graphics.translate(self.t.translation:get_xy())
	love.graphics.rotate(self.t.rotation)
	love.graphics.scale(self.t.scale:get_xy())
end

Camera.apply_filters = function(self)
	for _, value in ipairs(self.filters) do
		self = value(self)
	end
end

Camera.look_at = function(self, target)
	local centered = function()
		local screen_size = Vec2.new(love.graphics.getWidth(), love.graphics.getHeight())
		return (target.translation - (screen_size * Vec2.new(0.5))) * Vec2.new(-1)
	end
	self.t.translation = centered()
end

---create new camera with filters
---@param filters function[] filter takes camera and must return it back
---@return table
Camera.new = function(filters)
	return setmetatable(utils.transfer_funcs({ t = Transform.default(), filters = filters }, Camera), {})
end

return Camera
