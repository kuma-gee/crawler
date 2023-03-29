local InputEvent = require 'lib.input.input-event'
local MouseMoveEvent = InputEvent:extend()

function MouseMoveEvent:new(x, y, pressed)
	MouseMoveEvent.super.new(self, pressed)
	self.x = x
	self.y = y
end

function MouseMoveEvent:getPosition()
	return self.x, self.y
end

function MouseMoveEvent:setPosition(x, y)
	self.x, self.y = x, y
end

return MouseMoveEvent
