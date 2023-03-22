local Widget = Class:extend({
	_pos = Vector(0, 0),
	_size = Vector(0, 0),
	_pad = { 0, 0, 0, 0 },
	debugColor = { 1, 0, 0, 1 }
})

function Widget:_fontSize()
	local font = love.graphics.getFont()
	return font:getHeight()
end

function Widget:_getTopPadding()
	return self._pad[1] * self:_fontSize()
end

function Widget:_getRightPadding()
	return self._pad[2] * self:_fontSize()
end

function Widget:_getBottomPadding()
	return self._pad[3] * self:_fontSize()
end

function Widget:_getLeftPadding()
	return self._pad[4] * self:_fontSize()
end

function Widget:getOuterSize()
	return Vector(
		self._size.x + self:_getLeftPadding() + self:_getRightPadding(),
		self._size.y + self:_getTopPadding() + self:_getBottomPadding()
	);
end

function Widget:getInnerSize()
	return self._size:clone()
end

function Widget:setInnerSize(size)
	self._size = size
end

function Widget:setTopLeftCorner(pos)
	self._pos = pos
end

function Widget:getTopLeftCorner()
	return self._pos:clone()
end

function Widget:getBottomRightCorner()
	return self._pos + self:getOuterSize()
end

function Widget:getInnerTopLeftCorner()
	return self._pos + Vector(self:_getLeftPadding(), self:_getTopPadding())
end

function Widget:getMousePosition()
	return Vector(love.mouse.getX(), love.mouse.getY())
end

function Widget:drawInColor(col, fn)
	local c = col or { 0, 0, 0, 1 }
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(c[1], c[2], c[3], c[4])
	fn()
	love.graphics.setColor(r, g, b, a)
end

-- Theme related

function Widget:setTheme(theme)
	self:setPadding(theme.padding)
	return self
end

function Widget:setPadding(v)
	if type(v) == 'table' then
		if #v >= 4 then
			self._pad = { v[1], v[2], v[3], v[4] }
		elseif #v >= 2 then
			self._pad = { v[1], v[2], v[1], v[2] }
		else
			self._pad = { v[1], v[1], v[1], v[1] }
		end
	elseif not (v == nil) then
		self._pad = { v, v, v, v }
	end

	return self
end

-- Override in sub classes if needed

function Widget:mousepressed(...)
end

function Widget:mousereleased(...)
end

function Widget:draw()
	self:drawInColor(self.debugColor, function()
		love.graphics.circle('fill', self._pos.x, self._pos.y, 2)

		local botRight = self:getBottomRightCorner()
		love.graphics.circle('fill', botRight.x, botRight.y, 2)
	end)
end

function Widget:update()
end

return Widget
