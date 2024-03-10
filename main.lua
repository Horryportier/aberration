local inspect = require("inspect").inspect

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

Game = {
	dt = 0,
	bg_color = Color.new(0.2),
	---@type Entity[]
	entities = {},
	debug = false,
	current_debug = 0,
	font = love.graphics.newFont(16),
}

local player_movement = function(self)
	local v = (love.keyboard.isDown("a") and Vec2.LEFT or Vec2.ZERO)
		+ (love.keyboard.isDown("e") and Vec2.RIGHT or Vec2.ZERO)
		+ (love.keyboard.isDown("space") and Vec2.UP * Vec2.new(10) or Vec2.ZERO)
	self.velocity = v
end
local player_scale = 2

Game.sanitise = function(self)
	return utils.strip_functions(self)
end

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	local setup_world = function()
		World = love.physics.newWorld(0, 200, true)
	end
	setup_world()
	Game.entities.player = Entity.builder(World, "sword.png", {
		sprite = sb("sword.png", 32),
		b = pbb(World, bb("dynamic", Vec2.new(200):get_xy()), bsb("rectangle", { 32 * 1, 32 * (player_scale * 0.9) })),
		shader = Entity.shader_builder("distortion.glsl", { velocity = Vec2.default():as_array() }, function(self)
			self.shader_uniforms.velocity = self.velocity:normalize():as_array()
		end),
		t = Transform.new(Vec2.default(), 0, Vec2.new(player_scale)),
		move = player_movement,
	})

	Map.load_level(Game, World, "level1.txt", 32)
end

local pre_draw = function()
	Game.bg_color:set(love.graphics.setBackgroundColor)
	love.graphics.setFont(Game.font)
	Camera:apply_filters()
	Camera:update()
end

function love.draw()
	pre_draw()

	for _, value in pairs(Game.entities) do
		if value.shader_send then
			Camera:look_at(Game.entities.player.t)
			value:shader_send(Game.dt)
		end
		value:draw()
		if Game.debug then
			value:sd()
		end
	end
	local old_color = Color.new(love.graphics.getColor())
	love.graphics.setColor(Color.default():normalize():unpack())
	if Game.debug then
		--love.graphics.print(inspect(Game:sanitise().entities.player))
		love.graphics.print(inspect(utils.strip_functions(Camera)))
	end
	love.graphics.setColor(old_color:unpack())
end

function love.update(dt)
	Game.dt = dt
	for _, value in pairs(Game.entities) do
		value:sync_trasfroms()
		if value.move then
			value:move()
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
end
