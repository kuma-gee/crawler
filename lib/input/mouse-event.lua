local MouseEvent = Class:extend()

function MouseEvent:new(pos, button, pressed)
	self._pos = pos
	self._button = button
	self._pressed = pressed
end

function MouseEvent:getPosition()
	return self._pos
end

function MouseEvent:isPressed()
	return self._pressed
end

function MouseEvent:isLeftButton()
	return self._button == 1
end

return MouseEvent
