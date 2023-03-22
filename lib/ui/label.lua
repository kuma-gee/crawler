local Widget = require 'lib.ui.widget'
local Label = Widget:extend()

function Label:new(t)
	Label.super.new(self)
	self._text = t
	self._textColor = { 0, 0, 0, 1 }
end

function Label:setText(t)
	self._text = tostring(t)
	self:setInnerSize(Vector.ZERO) -- allow size to shrink
end

function Label:update()
	self:_updateSizeForText()
end

function Label:_updateSizeForText()
	local font = love.graphics.getFont()
	local size = self:getInnerSize()

	self:setInnerSize(Vector(
		math.max(font:getWidth(self._text), size.x),
		math.max(font:getHeight(), size.y)
	))
end

function Label:draw()
	Label.super.draw(self)

	local innerPos = self:getInnerTopLeftCorner()
	local innerSize = self:getInnerSize()

	self:drawInColor(self._textColor, function()
		love.graphics.printf(self._text, innerPos.x, innerPos.y, innerSize.x, "left")
	end)
end

function Label:withTheme(theme)
	Label.super.withTheme(self, theme)

	if theme.color then
		self._textColor = theme.color
	end

	return self
end

return Label
