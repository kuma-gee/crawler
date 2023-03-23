local Node2D = require 'lib.node.node2d'
local Control = Node2D:extend()

function Control:new()
	Control.super.new(self)
	self._size = Vector(0, 0)
	self._logger = Logger.new('Control')
end

function Control:getSize()
	return self._size:clone()
end

function Control:setSize(size)
	if Vector.isvector(size) then
		self._size = size
	else
		self._logger:warn('Invalid value for size: ' .. tostring(size))
	end
	return self
end

function Control:setTheme(_)
	return self
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
