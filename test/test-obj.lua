local Node2D = require 'lib.node.node2d'
local TestObj = Node2D:extend()

function TestObj:new(color)
	TestObj.super.new(self)
	self.c = color
end

function TestObj:drawLocal()
	love.graphics.setColor(self.c)
	love.graphics.rectangle('fill', 0, 0, 5, 5)
	love.graphics.setColor({ 1, 1, 1, 1 })
end

return TestObj
