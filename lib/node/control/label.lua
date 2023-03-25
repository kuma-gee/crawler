local Control = require 'lib.node.control'
local Label = Control:extend()

function Label:new(t)
	Label.super.new(self)
	self._text = t or ''
	self._textColor = { 0, 0, 0, 1 }
end

function Label:setText(t)
	self._text = tostring(t)
	self:setSize(Vector.ZERO) -- allow size to shrink
end

function Label:update(_)
	Label.super.update(self, _)
	self:_updateSizeForText()
end

function Label:_updateSizeForText()
	local font = love.graphics.getFont()
	local size = self:getSize()

	self:setSize(Vector(
		math.max(font:getWidth(self._text), size.x),
		math.max(font:getHeight(), size.y)
	))
end

function Label:draw()
	local pos = self:getPosition()
	local size = self:getSize()

	self:drawInColor(self._textColor, function()
		love.graphics.printf(self._text, pos.x, pos.y, size.x, "left")
	end)

	Label.super.draw(self)
end

function Label:setTheme(theme)
	if theme.color then
		self._textColor = theme.color
	end

	return Label.super.setTheme(self, theme)
end

return Label
