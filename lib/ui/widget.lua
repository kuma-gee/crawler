local Widget = { _pos = Vector(0, 0), _size = Vector(0, 0), _pad = { 0, 0, 0, 0 } }
Widget.__index = Widget

function Widget:_getTopPadding()
	return self._pad[1]
end

function Widget:_getRightPadding()
	return self._pad[2]
end

function Widget:_getBottomPadding()
	return self._pad[3]
end

function Widget:_getLeftPadding()
	return self._pad[4]
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
	end

	self._pad = { v, v, v, v }
end

function Widget:getOuterSize()
	return Vector(
		self._size.x + self:_getLeftPadding() + self:_getRightPadding(),
		self._size.y + self:_getTopPadding() + self:_getBottomPadding()
	);
end

function Widget:getInnerSize()
	return self._size
end

function Widget:setInnerSize(size)
	self._size = size
end

function Widget:setTopLeftCorner(pos)
	self._pos = pos
end

function Widget:getTopLeftCorner()
	return self._pos
end

function Widget:getBottomRightCorner()
	return self._pos + self:getOuterSize()
end

function Widget:getInnerTopLeftCorner()
	return self._pos + Vector(self:_getTopPadding(), self:_getLeftPadding())
end

function Widget:getMousePosition()
	return Vector(love.mouse.getX(), love.mouse.getY())
end

-- Override in sub classes if needed

function Widget:mousepressed(...) end

function Widget:mousereleased(...) end

function Widget:draw()
	love.graphics.setColor(1, 0, 0)
	love.graphics.circle('fill', self._pos.x, self._pos.y, 5)
end

function Widget:update() end

return Widget
