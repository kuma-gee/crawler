local Super = require 'lib.node.control'
local TestObj = Super:extend()

function TestObj:new(color)
	TestObj.super.new(self)
	self:setTheme({ background = color })
	self:setSize(5, 5)
end

return TestObj
