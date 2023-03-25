local width = 0
local height = 0

local function getScreenSize()
	return width, height
end

local function setScreenSize(w, h)
	width = w
	height = h
end

local function fromWidth(v)
	return width * v
end

local function fromHeight(v)
	return height * v
end

local function fromFont(v)
	local font = love.graphics.getFont()
	return v * font:getHeight()
end

return setmetatable({ w = fromWidth, h = fromHeight, rem = fromFont, setScreenSize = setScreenSize, getScreenSize = getScreenSize }, {})
