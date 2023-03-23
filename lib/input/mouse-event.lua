local MouseEvent = Class:extend()

function MouseEvent:new(button, pressed)
	self._button = button
	self._pressed = pressed
end

function MouseEvent:isPressed()
	return self._pressed
end

function MouseEvent:isLeftButton()
	return self._button == 1
end

return MouseEvent
