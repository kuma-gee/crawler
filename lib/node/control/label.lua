local Control = require 'lib.node.control'
local Label = Control:extend()

local defaultTheme = { color = { 0, 0, 0, 1 }, background = { 0, 0, 0, 0 } }

function Label.setDefaultTheme(theme)
	defaultTheme = table.merge(defaultTheme, theme)
end

function Label:new(t)
	Label.super.new(self)
	self._textSize = Vector.ZERO
	self:setText(t or '')
	self:setTheme(defaultTheme)
end

function Label:getText()
	return self._text
end

function Label:getSize()
	local size = Label.super.getSize(self)
	if size == Vector.ZERO then
		return self._textSize:clone()
	end

	return Vector(size.x, self._textSize.y)
end

function Label:setSize(size)
	Label.super.setSize(self, size)
	self:_updateSize()
	return self
end

function Label:setText(t)
	self._text = tostring(t)
	self:_updateSize()
end

function Label:_hasSize()
	return Label.super.getSize(self) ~= Vector.ZERO
end

function Label:_updateSize()
	local font = love.graphics.getFont()
	local size = self:getSize()

	if self:_hasSize() then
		local w, lines = font:getWrap(self._text, size.x)
		self._textSize = Vector(w, font:getHeight() * #lines)
	else
		self._textSize = Vector(font:getWidth(self._text), font:getHeight())
	end
end

function Label:drawLocal()
	local size = self:getSize()
	self:drawInColor(self:getTheme().color, function()
		love.graphics.printf(self._text, 0, 0, size.x, "left")
	end)
end

function Label:__tostring()
	return 'Label(text="' .. self:getText() .. '")'
end

return Label
