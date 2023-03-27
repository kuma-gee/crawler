local Node2D = require 'lib.node.node2d'
local Control = Node2D:extend()

function Control:new(anchor)
	Control.super.new(self)
	self._anchor = (anchor or Vector.TOP_LEFT):normalizedInGrid()
	self._size = Vector(0, 0)
	self._minSize = Vector(0, 0)
	self._logger = Logger.new('Control')
	self._bgColor = { 0, 0, 0, 0 }

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
	local size = self:getSize()
	local center = self:getPosition() - (self._anchor:multiply(size / 2))
	return center - (size / 2)
end

function Control:getSize()
	return Vector(
		math.max(self._minSize.x, self._size.x),
		math.max(self._minSize.y, self._size.y)
	)
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

function Control:setTheme(theme)
	if theme.background then
		self._bgColor = theme.background
	end

	return self
end

function Control:draw()
	local pos = self:getTopLeftCorner()
	local size = self:getSize()

	self:drawInColor(self._bgColor, function()
		love.graphics.rectangle("fill", pos.x, pos.y, size.x, size.y)
	end)

	Control.super.draw(self)
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

return Control
