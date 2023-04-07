local Control = require 'lib.node.control'
local Label = Control:extend()

local defaultTheme = { color = { 0, 0, 0, 1 }, background = { 0, 0, 0, 0 } }

function Label.setDefaultTheme(theme)
	defaultTheme = table.merge(defaultTheme, theme)
end

function Label:new(t)
	Label.super.new(self)
	self:setText(t or '')
	self:setTheme(defaultTheme)
end

function Label:load()
	self:_updateSizeForText()
end

function Label:getText()
	return self._text
end

function Label:setText(t)
	self._text = tostring(t)
	-- self:setMinSize(Vector.ZERO) -- allow size to shrink
	self:_updateSizeForText()
end

function Label:_updateSizeForText()
	local font = love.graphics.getFont()
	self:setSize(Vector(font:getWidth(self._text), font:getHeight()))


	-- self:setMinSize(size:max(Vector(font:getWidth(self._text), font:getHeight())))
end

function Label:draw()
	Label.super.draw(self)

	local size = self:getSize()
	self:drawInColor(self:getTheme().color, function()
		love.graphics.printf(self._text, 0, 0, size.x, "left")
	end)
end

function Label:__tostring()
	return 'Label(text="' .. self:getText() .. '")'
end

return Label
