local inspect = require("inspect").inspect
local Utils = {}
Utils.transfer_funcs = function(t, mt)
	for key, value in pairs(mt) do
		if type(value) == "function" then
			t[key] = value
		end
	end
	return t
end

Utils.strip_functions = function(t)
	local nt = {}
	for key, value in pairs(t) do
		if type(value) == "table" then
			nt[key] = Utils.strip_functions(value)
		elseif type(value) ~= "function" then
			nt[key] = value
		end
	end
	return nt
end

function Typeof(x)
	if x.__type then
		return x.__type()
	end
	return type(x)
end
function Utils.next_line(s)
        if s:sub(-1)~="\n" then s=s.."\n" end
        return s:gmatch("(.-)\n")
end

return Utils
