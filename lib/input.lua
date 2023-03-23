local MouseEvent = require 'lib.input.mouse-event'
local KeyEvent = require 'lib.input.key-event'
local Input = Class:extend()

function Input:new()
	self.onInput = Signal()
end

function Input:mousepressed(x, y, button)
	self.onInput:emit(MouseEvent(Vector(x, y), button, true))
end

function Input:mousereleased(x, y, button)
	self.onInput:emit(MouseEvent(Vector(x, y), button, false))
end

function Input:keypressed(key)
	self.onInput:emit(KeyEvent(key, true))
end

function Input:keyreleased(key)
	self.onInput:emit(KeyEvent(key, false))
end

return Input()
