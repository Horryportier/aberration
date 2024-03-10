local inspect = require("inspect").inspect
local drawable_mt = {}


local Drawable = {
	new = function(t)
		---@param self Entity
		t.draw = function(self)
			if self.shader_uniforms and self.shader then
				for key, value in pairs(self.shader_uniforms) do
					self.shader:send(key, value)
				end
			end
			if self.shader then
				love.graphics.setShader(self.shader)
			end
			local tt, tr, ts, to = self.t:get()
			local res = self.resolution * Vec2.new(0.5)
			love.graphics.draw(self.sprite, tt.x, tt.y, tr, ts.x, ts.y, to.x + res.x, to.y + res.y)
			love.graphics.setShader()
		end
		return setmetatable(t, drawable_mt)
	end,
}

return Drawable
