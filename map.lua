local Entity = require("entity")
local utils = require("utils")
local inspect = require("inspect").inspect

local pbb = require("entity").physics_body_builder
local bb = require("entity").body_builder
local bsb = require("entity").shape_builder
local sb = require("entity").sprite_builder

local Map = {}

local function format_name(x, y)
	return string.format("tile<%d,%d>", x, y)
end
local tile_builder = function(tile)
	return function(World, x, y, resolution)
		return Entity.builder(World, format_name(x, y), {
			b = pbb(
				World,
				bb("static", math.ceil(x * resolution), math.ceil(y * resolution)),
				bsb("rectangle", { 32, 32 })
			),
			sprite = sb(tile, resolution),
			shader = Entity.shader_builder(
				"tile_shader.glsl",
				{ modulate = Color.new(179, 45, 145, 1):normalize():as_array() }
			),
		})
	end
end

local tiles_ids = {
	["_"] = tile_builder("tile1.png"),
	["2"] = tile_builder("tile2.png"),
	["#"] = tile_builder("tile3.png"),
	["4"] = tile_builder("tile4.png"),
	["-"] = tile_builder("tile5.png"),
	["6"] = tile_builder("tile6.png"),
	["|"] = tile_builder("tile7.png"),
	["8"] = tile_builder("tile8.png"),
	["e"] = function(World, x, y, resolution)
		return Entity.builder(World, "enemy", {
			b = pbb(
				World,
				bb("dynamic", math.ceil(x * resolution), math.ceil(y * resolution)),
				bsb("rectangle", { 32 * 0.5, 32 * 0.9 })
			),
			sprite = sb("sword.png", resolution),
			shader = Entity.shader_builder("distortion.glsl", { velocity = Vec2.default() }, function(self)
				self.shader_uniforms.velocity = self.velocity:normalize():as_array()
			end),
		})
	end,
	["*"] = function(World, x, y, resolution)
		return Entity.builder(World, "coin", {
			b = pbb(
				World,
				bb("dynamic", math.ceil(x * resolution), math.ceil(y * resolution)),
				bsb("circle", resolution / 2)
			),
			sprite = sb("coin.png", resolution),
			shader = Entity.shader_builder("distortion.glsl", { velocity = Vec2.default() }, function(self)
				self.shader_uniforms.velocity = self.velocity:normalize():as_array()
			end),
			move = function(self, dt)
				self.velocity = Vec2.UP
			end,
		})
	end,
}

function Map.load_level(Game, World, path, resolution)
	local file = love.filesystem.read(path, 100000)
	local y = 0
	for line in utils.next_line(file) do
		local x = 0
		for i = 1, #line, 1 do
			local matched = tiles_ids[line:sub(i, i)]
			if matched then
				table.insert(Game.entities, matched(World, x, y, resolution))
			end
			x = x + 1
		end
		y = y + 1
	end
end

return Map
