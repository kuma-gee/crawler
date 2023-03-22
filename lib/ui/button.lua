local Container = require 'lib.ui.container'
local Button = setmetatable({}, { __index = Container.new(Vector.RIGHT) })
Button.__index = Button

function Button.new()
	return setmetatable(
		{
			isHover = false,
			isPressed = false,
			onClick = Signal(),
			debugColor = { 0, 1, 0, 1 },
			_logger = Logger.new('Button')
		},
		Button)
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

return Button
