local MouseButtonEvent  = require 'lib.input.mouse-button-event'
local MouseEvent        = require 'lib.input.mouse-event'
local Container         = require 'lib.node.control.container'
local Button            = Container:extend()

local defaultTheme      = { background = { 0, 0, 0, 0 } }
local hoverDefaultTheme = { background = { 1, 1, 1, 0.2 } }

function Button.setDefaultTheme(theme)
	defaultTheme = table.merge(defaultTheme, theme)
end

function Button.setDefaultHoverTheme(theme)
	hoverDefaultTheme = table.merge(hoverDefaultTheme, theme)
end

function Button:new()
	Button.super.new(self, Vector.RIGHT)
	self.onClick = Signal()

	self._dir = Vector.RIGHT
	self._isHover = false
	self._isPressed = false
	self._logger = Logger.new('Button')

	self._hoverTheme = hoverDefaultTheme
	self:setTheme(defaultTheme)
end

function Button:isHover()
	return self._isHover
end

function Button:isPressed()
	return self._isPressed
end

function Button:_updateHover(ev)
	local mx, my = ev:getPosition()
	local topLeft = self:getPosition()
	local botRight = topLeft + self:getSize()

	local insideX = mx > topLeft.x and mx < botRight.x
	local insideY = my > topLeft.y and my < botRight.y
	self._isHover = insideX and insideY
end

function Button:getTheme()
	if self._isHover then
		return self._hoverTheme
	end

	return Button.super.getTheme(self)
end

function Button:input(event)
	if event:is(MouseEvent) then
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
	self._hoverTheme = table.merge(self._hoverTheme, theme)
	return self
end

function Button:__tostring()
	return 'Button()'
end

return Button
