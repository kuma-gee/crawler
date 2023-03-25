local InputEvent = require 'lib.input.input-event'
local ResizeEvent = InputEvent:extend()

function ResizeEvent:new(w, h)
	self.w = w
	self.h = h
end

function ResizeEvent:getSize()
	return self.w, self.h
end

return ResizeEvent
