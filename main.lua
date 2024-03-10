local inspect = require("inspect").inspect
local Player = require("player")

local utils = require("utils")
local Transform = require("transform")
local Color = require("color")
local Entity = require("entity")
local Map = require("map")
local Camera = require("camera").new({})

local pbb = require("entity").physics_body_builder
local bb = require("entity").body_builder
local bsb = require("entity").shape_builder
local sb = require("entity").sprite_builder

--- TODO:
-- clean up this file
-- debug - show data of currently cliked entity
-- tweennig - implemnet basic tweennig functions
-- animation - create animation abstraction
-- enemies - meka basic enemies
-- points - make collectabeles and score
-- ui - basic ui
--- NOTE:
--- later maybe make most things work in async will see

Game = {
	bg_color = Color.new(0.2),
	---@type Entity
	---@type Entity[]
	entities = {},
	debug = false,
	current_debug = 0,
	font = love.graphics.newFont(16),
}

Game.sanitise = function(self)
	return utils.strip_functions(self)
end

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	World = love.physics.newWorld(0, 200, true)
	Game.player = Player(World)
	Map.load_level(Game, World, "level1.txt", 32)
end

local pre_draw = function()
	Game.bg_color:set(love.graphics.setBackgroundColor)
	love.graphics.setFont(Game.font)
	Camera:apply_filters()
	Camera:update()
end

local function draw_player()
	Game.player:draw()
	if Game.debug then
		Game.player:sd()
	end
end

function debug()
	local old_color = Color.new(love.graphics.getColor())
	love.graphics.setColor(Color.default():normalize():unpack())
	for _, value in pairs(Game.entities) do
		value:draw()
		if Game.debug then
			value:sd()
		end
	end

	if Game.debug then
		love.graphics.print(
			inspect(Game:sanitise().entities[Game.current_debug]),
			(Camera.t.translation * Vec2.new(-1)):get_xy()
		)
	end
	love.graphics.setColor(old_color:unpack())
end

function love.draw()
	pre_draw()
	draw_player()

	Camera:look_at(Game.player.t)

	debug()
end

local function update_player(dt)
	Game.player:sync_trasfroms()
	Game.player:move(dt)
	Game.player:shader_send(dt)
end

function love.update(dt)
	update_player(dt)
	for _, value in pairs(Game.entities) do
		value:sync_trasfroms()
		if value.shader_send then
			value:shader_send(dt)
		end

		if value.move then
			value:move(dt)
		end
	end
	World:update(dt, 100, 100)
end
function love.keypressed(key)
	if key == "f" then
		Game.debug = not Game.debug
	end
	if key == "j" then
		Game.current_debug = Game.current_debug + 1
	end
	if key == "k" then
		if Game.current_debug ~= 0 then
			Game.current_debug = Game.current_debug - 1
		end
	end
	local zoom_change = Vec2.new(0.2)
	local zoom_min = Vec2.new(0.1)
	local zoom_max = Vec2.new(4)

	--- FIX:
	-- its one and not + because
	if key == "1" then
		Camera.t.scale = Camera.t.scale + zoom_change
	end
	if key == "-" then
		Camera.t.scale = Camera.t.scale - zoom_change
	end
	Camera.t.scale:clamp(zoom_min, zoom_max)
end
