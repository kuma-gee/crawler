local Widget = require 'lib.ui.widget'
local Label = setmetatable({}, { __index = Widget.new() })
Label.__index = Label

function Label.new(t)
	return setmetatable({ text = t }, Label)
end

function Label:update()
	self:_updateSizeForText()
	print("Label: "..tostring(self:getOuterSize()))
end

function Label:_updateSizeForText()
	local font = love.graphics.getFont()
	local size = self:getInnerSize()

	self:setInnerSize(Vector(
		math.max(font:getWidth(self.text), size.x),
		math.max(font:getHeight(), size.y)
	))
end

function Label:draw()
	local innerPos = self:getInnerTopLeftCorner()
	local innerSize = self:getInnerSize()
	love.graphics.printf(self.text, innerPos.x, innerPos.y, innerSize.x, "center")

	Widget.draw(self)
end

return Label
