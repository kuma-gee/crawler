local InputEvent = require 'lib.input.input-event'
local KeyEvent = InputEvent:extend()

function KeyEvent:new(key, pressed)
	KeyEvent.super.new(self, pressed)
	self._key = key
end

function KeyEvent:getKey()
	return self._key
end

return KeyEvent
