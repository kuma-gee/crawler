local MouseEvent = require 'lib.input.mouse-event'
local Container = require 'lib.node.control.container'
local Button = Container:extend()

function Button:new()
	Button.super.new(self, Vector.RIGHT)
	self.onClick = Signal()

	self._dir = Vector.RIGHT
	self._isHover = false
	self._isPressed = false
	self._logger = Logger.new('Button')
end

function Button:isHover()
	return self._isHover
end

function Button:isPressed()
	return self._isPressed
end

function Button:update(_)
	Button.super.update(self, _)
	self:_updateHover()
end

function Button:_updateHover()
	local mouse = self:getMousePosition()
	local topLeft = self:getPosition()
	local botRight = topLeft + self:getSize()

	local insideX = mouse.x > topLeft.x and mouse.x < botRight.x
	local insideY = mouse.y > topLeft.y and mouse.y < botRight.y
	self._isHover = insideX and insideY
end

function Button:input(event)
	if event:is(MouseEvent) and event:isLeftButton() then
		self._isPressed = event:isPressed()
		if self._isPressed then
			self.onClick:emit()
		end
	end

	Button.super.input(self, event)
end

return Button
