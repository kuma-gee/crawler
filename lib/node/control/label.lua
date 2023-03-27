local Control = require 'lib.node.control'
local Label = Control:extend()

function Label:new(t)
	Label.super.new(self)
	self:setText(t or '')
	self._textColor = { 0, 0, 0, 1 }
end

function Label:load()
	self:_updateSizeForText()
end

function Label:getText()
	return self._text
end

function Label:setText(t)
	self._text = tostring(t)
	self:setMinSize(Vector.ZERO) -- allow size to shrink
	self:_updateSizeForText()
end

function Label:_updateSizeForText()
	local font = love.graphics.getFont()
	local size = self:getMinSize()

	self:setMinSize(size:maximize(Vector(font:getWidth(self._text), font:getHeight())))
end

function Label:draw()
	Label.super.draw(self)

	local pos = self:getPosition()
	local size = self:getSize()

	self:drawInColor(self._textColor, function()
		love.graphics.printf(self._text, pos.x, pos.y, size.x, "left")
	end)
end

function Label:setTheme(theme)
	if theme.color then
		self._textColor = theme.color
	end

	return Label.super.setTheme(self, theme)
end

function Label:__tostring()
	return 'Label(text="' .. self:getText() .. '")'
end

return Label
