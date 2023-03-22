local Widget = require 'lib.ui.widget'
local Label = Widget:extend({ text = "", _textColor = { 0, 0, 0, 1 } })

function Label:constructor(t)
	self.text = t
end

function Label:update()
	self:_updateSizeForText()
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

	self:drawInColor(self._textColor, function()
		love.graphics.printf(self.text, innerPos.x, innerPos.y, innerSize.x, "center")
	end)

	-- Widget.draw(self)
end

function Label:setTheme(theme)
	Widget.setTheme(self, theme)

	if theme.color then
		self._textColor = theme.color
	end
end

return Label
