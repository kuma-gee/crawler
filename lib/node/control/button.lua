local MouseButtonEvent = require 'lib.input.mouse-button-event'
local MouseMoveEvent = require 'lib.input.mouse-move-event'
local Container = require 'lib.node.control.container'
local Button = Container:extend()

function Button:new()
	Button.super.new(self, Vector.RIGHT)
	self.onClick = Signal()

	self._dir = Vector.RIGHT
	self._isHover = false
	self._isPressed = false
	self._logger = Logger.new('Button')
	self._hoverTheme = {}
end

function Button:isHover()
	return self._isHover
end

function Button:isPressed()
	return self._isPressed
end

function Button:_updateHover(ev)
	local mouse = ev:getPosition()
	local topLeft = self:getPosition()
	local botRight = topLeft + self:getSize()

	local insideX = mouse.x > topLeft.x and mouse.x < botRight.x
	local insideY = mouse.y > topLeft.y and mouse.y < botRight.y
	self._isHover = insideX and insideY
end

function Button:getTheme()
	if self._isHover then
		return self._hoverTheme
	end

	return Button.super.getTheme(self)
end

function Button:input(event)
	if event:is(MouseMoveEvent) then
		self:_updateHover(event)
	end

	if self._isHover and event:is(MouseButtonEvent) and event:isLeftButton() then
		self._isPressed = event:isPressed()
		if self._isPressed then
			self.onClick:emit()
		end
	end

	Button.super.input(self, event)
end

function Button:setHoverTheme(theme)
	self._hoverTheme = theme
	return self
end

return Button
