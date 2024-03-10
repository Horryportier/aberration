local shader_loader = {}

---@param path string
---@return love.Shader
function shader_loader.load(path)
	local contents, s = love.filesystem.read(path, 10000)
	if type(s) == "string" then
		error(s, 1)
	end
	return love.graphics.newShader(contents)
end

return shader_loader
