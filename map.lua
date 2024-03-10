local Entity = require("entity")
local utils = require("utils")

local pbb = require("entity").physics_body_builder
local bb = require("entity").body_builder
local bsb = require("entity").shape_builder
local sb = require("entity").sprite_builder

local Map = {}

local tiles_ids = {
	["1"] = "tile1.png",
	["2"] = "tile2.png",
	["3"] = "tile3.png",
	["4"] = "tile4.png",
	["5"] = "tile5.png",
	["6"] = "tile6.png",
	["7"] = "tile7.png",
	["8"] = "tile8.png",
}

local function format_name(x, y)
	return string.format("tile<%d,%d>", x, y)
end

function Map.load_level(Game, World, path, resolution)
	local file = love.filesystem.read(path, 100000)
	local y = 0
	for line in utils.next_line(file) do
		local x = 0
		for i = 1, #line, 1 do
			local matched = tiles_ids[line:sub(i, i)]
			print(matched)
			if matched then
				table.insert(
					Game.entities,
					Entity.builder(World, format_name(x, y), {
						b = pbb(World, bb("static", x * resolution, y * resolution), bsb("rectangle", { 32, 32 })),
						sprite = sb(matched, 32),
						shader = Entity.shader_builder(
							"tile_shader.glsl",
							{ modulate = Color.new(179, 45, 145, 1):normalize():as_array() }
						),
					})
				)
			end
			x = x + 1
		end
		y = y + 1
	end
end

return Map
