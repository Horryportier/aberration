local Entity = require("entity")
local Transform = require("transform")

local pbb = require("entity").physics_body_builder
local bb = require("entity").body_builder
local bsb = require("entity").shape_builder
local sb = require("entity").sprite_builder

local player_movement = function(self)
	local speed = Vec2.new(self.speed) or Vec2.ZERO
	local v = (love.keyboard.isDown("a") and Vec2.LEFT * speed or Vec2.ZERO)
		+ (love.keyboard.isDown("e") and Vec2.RIGHT * speed or Vec2.ZERO)
		+ (love.keyboard.isDown("space") and Vec2.UP * Vec2.new(10) or Vec2.ZERO)
	self.velocity = v
end
local player_scale = 2

return function(World)
	return Entity.builder(World, "player", {
		sprite = sb("sword.png", 32),
		b = pbb(World, bb("dynamic", Vec2.new(200):get_xy()), bsb("rectangle", { 32 * 1, 32 * (player_scale * 0.9) })),
		shader = Entity.shader_builder("distortion.glsl", { velocity = Vec2.default():as_array() }, function(self)
			self.shader_uniforms.velocity = self.velocity:normalize():as_array()
		end),
		t = Transform.new(Vec2.default(), 0, Vec2.new(player_scale)),
		move = player_movement,
	}, { speed = 5 })
end
