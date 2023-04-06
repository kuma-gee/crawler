local MouseButtonEvent = require 'lib.input.mouse-button-event'
local MouseEvent = require 'lib.input.mouse-event'
local KeyEvent = require 'lib.input.key-event'
local ResizeEvent = require 'lib.input.resize-event'

local Input = Class:extend()

function Input:new()
	self.onInput = Signal()
end

function Input:mousepressed(x, y, button)
	self.onInput:emit(MouseButtonEvent(button, true))
end

function Input:mousereleased(x, y, button)
	self.onInput:emit(MouseButtonEvent(button, false))
end

function Input:mousemoved(x, y, dx, dy, istouch)
	self.onInput:emit(MouseEvent(x, y))
end

function Input:keypressed(key)
	self.onInput:emit(KeyEvent(key, true))
end

function Input:keyreleased(key)
	self.onInput:emit(KeyEvent(key, false))
end

function Input:resize(w, h)
	self.onInput:emit(ResizeEvent(Unit.w(1), Unit.h(1)))
end

return Input()
