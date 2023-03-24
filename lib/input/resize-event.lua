local InputEvent = require 'lib.input.input-event'
local ResizeEvent = InputEvent:extend()

function ResizeEvent:new(w, h)
	self._size = Vector(w, h)
end

function ResizeEvent:getSize()
	return self._size
end

return ResizeEvent
