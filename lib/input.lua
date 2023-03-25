local MouseButtonEvent = require 'lib.input.mouse-button-event'
local MouseMoveEvent = require 'lib.input.mouse-move-event'
local KeyEvent = require 'lib.input.key-event'
local ResizeEvent = require 'lib.input.resize-event'
local push = require 'lib.push'

local Input = Class:extend()

function Input:new()
	self.onInput = Signal()
end

function Input:load()
	self:resize(Unit.getScreenSize())
end

function Input:mousepressed(x, y, button)
	self.onInput:emit(MouseButtonEvent(self:_toGameScreen(x, y), button, true))
end

function Input:mousereleased(x, y, button)
	self.onInput:emit(MouseButtonEvent(self:_toGameScreen(x, y), button, false))
end

function Input:mousemoved(x, y, dx, dy, istouch)
	self.onInput:emit(MouseMoveEvent(self:_toGameScreen(x, y)))
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

function Input:_toGameScreen(x, y)
	return Vector(push:toGame(x, y))
end

return Input()
