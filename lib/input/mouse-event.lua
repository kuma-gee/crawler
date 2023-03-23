local InputEvent = require 'lib.input.input-event'
local MouseEvent = InputEvent:extend()

function MouseEvent:new(pos, button, pressed)
	MouseEvent.super.new(self, pressed)
	self._pos = pos
	self._button = button
end

function MouseEvent:getPosition()
	return self._pos
end

function MouseEvent:isLeftButton()
	return self._button == 1
end

return MouseEvent
