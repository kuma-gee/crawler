local Node2D = require 'lib.node.node2d'
local Control = Node2D:extend()

local defaultTheme = { background = { 0, 0, 0, 0 } }

function Control:new(anchor)
	Control.super.new(self)
	self._anchor = (anchor or Vector.TOP_LEFT):normalizedInGrid()
	self._size = Vector.ZERO
	self._minSize = Vector.ZERO
	self._maxSize = Vector.ZERO
	self._logger = Logger.new('Control')
	self._theme = defaultTheme

	self._grow = false
end

function Control:isGrow()
	return self._grow
end

function Control:setGrow(grow)
	self._grow = grow
	return self
end

function Control:getTopLeftCorner()
	return self:getCenter() - (self:getSize() / 2)
end

function Control:getCenter()
	local size = self:getSize()
	return Vector.ZERO - self._anchor:multiply(size / 2)
end

function Control:getMinSize()
	return self._minSize
end

function Control:getSize()
	local max = self._maxSize
	local size = self:getMinSize():max(self._size)
	if max:len2() > 0 then
		size = size:min(max)
	end

	return size
end

function Control:setSize(size, y)
	if Vector.isvector(size) then
		self._size = size
	elseif size ~= nil and y ~= nil then
		self._size = Vector(size, y)
	else
		self._logger:warn('Invalid value for size: ' .. tostring(size))
	end
	return self
end

function Control:setFixedSize(size, y)
	return self:setMinSize(size, y):setMaxSize(size, y)
end

function Control:setMinSize(size, y)
	if Vector.isvector(size) and size.x >= 0 and size.y >= 0 then
		self._minSize = size
	elseif size ~= nil and y ~= nil and size >= 0 and y >= 0 then
		self._minSize = Vector(size, y)
	else
		self._logger:warn('Invalid value for min size: ' .. tostring(size))
	end
	return self
end

function Control:setMaxSize(size, y)
	if Vector.isvector(size) and size.x >= 0 and size.y >= 0 then
		self._maxSize = size
	elseif size ~= nil and y ~= nil and size >= 0 and y >= 0 then
		self._maxSize = Vector(size, y)
	else
		self._logger:warn('Invalid value for max size: ' .. tostring(size))
	end
	return self
end

function Control:setTheme(theme)
	self._theme = table.merge(self._theme, theme)
	return self
end

function Control:getTheme()
	return self._theme
end

function Control:drawLocal()
	local pos = self:getTopLeftCorner()
	local size = self:getSize()

	self:drawInColor(self:getTheme().background, function()
		love.graphics.rectangle("fill", pos.x, pos.y, size.x, size.y)
	end)
end

function Control:getMousePosition()
	return Vector(love.mouse.getX(), love.mouse.getY())
end

function Control:drawInColor(col, fn)
	local c = col or { 0, 0, 0, 1 }
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(c[1], c[2], c[3], c[4])
	fn()
	love.graphics.setColor(r, g, b, a)
end

function Control:__tostring()
	return 'Control()'
end

return Control
