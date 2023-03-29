local InputEvent = require 'lib.input.input-event'
local ResizeEvent = InputEvent:extend()

function ResizeEvent:new(w, h)
	self.w = w
	self.h = h
end

function ResizeEvent:getSize()
	return self.w, self.h
end

function ResizeEvent:setSize(w, h)
	self.w, self.h = w, h
end

return ResizeEvent
