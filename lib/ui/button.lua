local Widget = require 'lib.ui.widget'
local Button = setmetatable({}, { __index = Widget })
Button.__index = Button

function Button.new()
	return setmetatable({ isHover = false, isPressed = false, onClick = Signal(), text = "" }, Button)
end

function Button:update()
	self:_updateSize()
	self:_updateHover()
end

function Button:mousepressed(x, y, button)
	if button == 1 and self.isHover then
		self.isPressed = true
	end
end

function Button:mousereleased(x, y, button)
	if button == 1 and self.isPressed then
		self.isPressed = false
		self.onClick:emit()
	end
end

function Button:_updateSize()
	local font = love.graphics.getFont()
	self.w = math.max(font:getWidth(self.text), self.w)
	self.h = math.max(font:getHeight(), self.h)
end

function Button:_updateHover()
	local mouseX = love.mouse.getX()
	local mouseY = love.mouse.getY()

	local insideX = mouseX > self.x and mouseX < self.x + self.w
	local insideY = mouseY > self.y and mouseY < self.y + self.h

	self.isHover = insideX and insideY
end

function Button:draw()
	local font = love.graphics.getFont()

	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	love.graphics.printf(self.text, self.x, self.y + (self.h / 2) - font:getHeight() / 2, self.w, "center")
end

return Button
