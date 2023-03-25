local InputEvent = require 'lib.input.input-event'
local MouseButtonEvent = InputEvent:extend()

function MouseButtonEvent:new(pos, button, pressed)
	MouseButtonEvent.super.new(self, pressed)
	self._pos = pos
	self._button = button
end

function MouseButtonEvent:getPosition()
	return self._pos
end

function MouseButtonEvent:isLeftButton()
	return self._button == 1
end

return MouseButtonEvent
