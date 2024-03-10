local shader = require("shader")
local Drawable = require("draw")
local Transform = require("transform")
---@class EntitySpec
---@field t Transform?
---@field velocity Vec2?
---@field b function
---@field sprite function?
---@field shader function?
---@field move function?
--
---@class Entity
---@field name string
---@field t Transform?
---@field velocity Vec2?
---@field b love.Body?
---@field s love.Shape|love.PolygonShape|love.CircleShape?
---@field sd function?
---@field f love.Fixture?
---@field sprite love.Image?
---@field shader love.Shader?
---@field shader_uniforms table?
---@field move function?
---@field sync_trasfroms function?
---@field resolution Vec2?
---@field draw function?
---@field shader_send  function?
local Entity = {}

local function if_exists(condition, fn)
	if condition then
		fn()
	end
end

--- creates functino that returns sprite and resolution
---@param path string
---@param resolution Vec2|number
function Entity.sprite_builder(path, resolution)
	return function()
		local res = (type(resolution) == "number") and Vec2.new(resolution) or resolution
		return love.graphics.newImage("assets/" .. path), res
	end
end

--- builds physics body
---@param type love.BodyType
---@param x number
---@param y number
---@return function
function Entity.body_builder(type, x, y)
	return function(World)
		return love.physics.newBody(World, x, y, type)
	end
end

---@enum ShapeType
ShapeType = {
	CIRCLE = "circle",
	RECTANGLE = "rectangle",
	EDGE = "edge",
}

local shape_builders = {
	[ShapeType.CIRCLE] = function(params)
		return love.physics.newCircleShape(params)
	end,
	[ShapeType.RECTANGLE] = function(params)
		return love.physics.newRectangleShape(unpack(params))
	end,
	[ShapeType.EDGE] = function(parmas)
		return love.physics.newEdgeShape(unpack(parmas))
	end,
}

local shape_debug = {
	[ShapeType.CIRCLE] = function(self)
		love.graphics.circle("line", self.b:getX(), self.b:getY(), self.s:getRadius(), 20)
	end,
	[ShapeType.RECTANGLE] = function(self)
		love.graphics.polygon("line", self.b:getWorldPoints(self.s:getPoints()))
	end,
	[ShapeType.EDGE] = function(self)
		love.graphics.line(self.s:getPoints())
	end,
}

---creates shape and debug functino dependent on type
---@param type ShapeType
---@param params List|number
---@return function
function Entity.shape_builder(type, params)
	return function()
		return shape_builders[type](params), shape_debug[type]
	end
end

---takes body function and shape function returns function that produces body, shape, shape_debug  and fixture
---@param World love.World
---@param body function -- body function must take world as first argument
---@param shape function
---@param mass number?
---@return  function
function Entity.physics_body_builder(World, body, shape, mass)
	---@return love.Body
	---@return love.Shape
	---@return function
	---@return love.Fixture
	---@return number
	local f = function()
		local b = body(World)
		local s, sd = shape()
		local f = love.physics.newFixture(b, s)
		return b, s, sd, f, mass or 0
	end
	return f
end

--- creates a function that returns shader and uniforms
---@param path string
---@param uniforms table|nil
---@return function
function Entity.shader_builder(path, uniforms, update_func)
	return function()
		return shader.load("shaders/" .. path), uniforms or {}, update_func or function(self, dt) end
	end
end

---@param World love.World
---@param name string
---@param opts EntitySpec
---@return unknown
Entity.builder = function(World, name, opts, other)
	---@type Entity
	local t = { name = name }
	t.t = opts.t ~= nil and opts.t or Transform.default()
	t.velocity = opts.velocity or Vec2.default()
	if_exists(opts.move, function()
		t.move = opts.move
	end)
	if_exists(opts.sprite, function()
		t.sprite, t.resolution = opts.sprite()
	end)
	if_exists(opts.b, function()
		local m = 0
		t.b, t.s, t.sd, t.f, m = opts.b(World)
		t.b:setMass(m)
	end)

	if_exists(opts.shader, function()
		t.shader, t.shader_uniforms, t.shader_send = opts.shader()
	end)
	t.sync_trasfroms = function(self)
		self.t.translation = Vec2.new(self.b:getPosition())
		self.t.rotation = self.b:getAngle()
		self.b:setLinearVelocity((Vec2.new(self.b:getLinearVelocity()) + self.velocity):get_xy())
	end

	for key, value in pairs(other or {}) do
		t[key] = value
	end

	t = Drawable.new(t)
	return t
end

return Entity
