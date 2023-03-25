local InputEvent = require 'lib.input.input-event'
local MouseMoveEvent = InputEvent:extend()

function MouseMoveEvent:new(pos)
	MouseMoveEvent.super.new(self)
	self._pos = pos
end

function MouseMoveEvent:getPosition()
	return self._pos
end

return MouseMoveEvent
