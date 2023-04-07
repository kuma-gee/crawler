local Element = require 'lib.ui.element'
local Label = Element:extend()

local defaultTheme = { color = { 0, 0, 0, 1 }, background = { 0, 0, 0, 0 } }

function Label.setDefaultTheme(theme)
	defaultTheme = table.merge(defaultTheme, theme)
end

function Label:new(t)
	Label.super.new(self)
	self:setText(t or '')
	self:setTheme(defaultTheme)
	self.x, self.y = 0, 0
	self.w, self.h = 0, 0
end

function Label:setPosition(x, y)
	self.x, self.y = x, y
end

function Label:setSize(w, h)
	self.w, self.h = w, h
end

function Label:getText()
	return self._text
end

function Label:setText(t)
	self._text = tostring(t)
end

function Label:draw()
	Element.drawInColor(self:getTheme().color, function()
		love.graphics.printf(self._text, self.x, self.y, self.w, "left")
	end)
end

function Label:__tostring()
	return 'Label(text="' .. self:getText() .. '")'
end

return Label
