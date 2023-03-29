local InputEvent = require 'lib.input.input-event'
local MouseButtonEvent = InputEvent:extend()

function MouseButtonEvent:new(button, pressed)
	MouseButtonEvent.super.new(self, pressed)
	self._button = button
end

function MouseButtonEvent:isLeftButton()
	return self._button == 1
end

return MouseButtonEvent
