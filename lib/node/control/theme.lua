local default = setmetatable({}, {
	padding = 0,
	background = { 0, 0, 0, 0 },
	color = { 0, 0, 0, 1 }
})

local function new(props)
	local result = {}
	for k, v in pairs(props) do
		result[k] = v or default[k]
	end

	return result
end

return setmetatable({ new = new }, {
	__call = function(_, ...) return new(...) end
})
