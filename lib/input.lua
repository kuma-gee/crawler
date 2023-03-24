local MouseEvent = require 'lib.input.mouse-event'
local KeyEvent = require 'lib.input.key-event'
local ResizeEvent = require 'lib.input.resize-event'

local Input = Class:extend()

function Input:new()
	self.onInput = Signal()
end

function Input:load()
	local w, h = love.graphics.getDimensions()
	self:resize(w, h)
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

function Input:resize(w, h)
	self.onInput:emit(ResizeEvent(w, h))
end

return Input()
