local Container = require 'lib.ui.container'
local Button = setmetatable({}, { __index = Container.new() })
Button.__index = Button

function Button.new()
	local btn = setmetatable({ isHover = false, isPressed = false, onClick = Signal(), _bgColor = { 0, 0, 0, 0 }, _logger = Logger.new('Button') }, Button)
	btn:setDirection(Container.Dir.ROW)
	return btn
end

function Button:update()
	Container.update(self)
	self:_updateHover()
end

function Button:_updateHover()
	local mouse = self:getMousePosition()
	local topLeft = self:getTopLeftCorner()
	local botRight = self:getBottomRightCorner()

	local insideX = mouse.x > topLeft.x and mouse.x < botRight.x
	local insideY = mouse.y > topLeft.y and mouse.y < botRight.y
	self.isHover = insideX and insideY
end

function Button:mousepressed(x, y, button)
	Container.mousepressed(self)

	if button == 1 and self.isHover then
		self.isPressed = true
	end
end

function Button:mousereleased(x, y, button)
	Container.mousereleased(self)

	if button == 1 and self.isPressed then
		self.isPressed = false
		self.onClick:emit()
	end
end

function Button:draw()
	local pos = self:getTopLeftCorner()
	local size = self:getOuterSize()

	self:drawInColor(self._bgColor, function()
		love.graphics.rectangle("fill", pos.x, pos.y, size.x, size.y)
	end)

	Container.draw(self)
end

function Button:setTheme(theme)
	print(theme)
	if theme.background then
		self._bgColor = theme.background
	end

	return Container.setTheme(self, theme)
end

return Button
