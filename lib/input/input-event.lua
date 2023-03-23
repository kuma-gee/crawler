local InputEvent = Class:extend()

function InputEvent:new(pressed)
	self._pressed = pressed
end

function InputEvent:isPressed()
	return self._pressed
end

return InputEvent
