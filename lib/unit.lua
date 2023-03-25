local function fromWidth(v)
	return love.graphics.getWidth() * v
end

local function fromHeight(v)
	return love.graphics.getHeight() * v
end

local function fromFont(v)
	local font = love.graphics.getFont()
	return v * font:getHeight()
end

return setmetatable({ w = fromWidth, h = fromHeight, rem = fromFont }, {})
