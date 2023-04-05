local Control = require 'lib.node.control'
local Container = Control:extend()

Container.Align = { Start = 'start', Center = 'center', End = 'end', Stretch = 'stretch' }

function Container:new(dir, anchor, align)
	Container.super.new(self, anchor)
	self._dir = (dir or Vector.DOWN):abs():normalizedInGrid()
	self._logger = Logger.new('Container')
	self._align = align or Container.Align.Start
end

function Container:_getInnerTopLeftCorner()
	return self:getTopLeftCorner()
end

function Container:update(_)
	self:_updateSize()

	local currPos = self:getTopLeftCorner()

	self:eachVisibleChild(function(child)
		child:setPosition(self:_getPositionForAlignment(currPos, child))
		currPos = currPos + child:getSize():multiply(self._dir)
	end)
end

function Container:_getPositionForAlignment(pos, child)
	local dir = self:_normalDir()
	if self._align == Container.Align.Center then
		local center = pos + self:getSize():multiply(dir / 2)
		return center - child:getSize():multiply(dir / 2)
	elseif self._align == Container.Align.End then
		local endPos = pos + self:getSize():multiply(dir)
		return endPos - child:getSize():multiply(dir)
	end

	return pos:clone()
end

function Container:_normalDir()
	return self._dir:perpendicular():abs()
end

function Container:_updateSize()
	local childrenSize = Vector(0, 0)
	local growChildren = {}
	self:eachVisibleChild(function(child)
		child:update()

		local childSize = child:getSize()
		childrenSize = childrenSize + childSize:multiply(self._dir)

		if self._dir * Vector.UP == 0 then
			childrenSize.y = math.max(childrenSize.y, childSize.y)
		else
			childrenSize.x = math.max(childrenSize.x, childSize.x)
		end

		if child:isGrow() then
			table.insert(growChildren, child)
		end
	end)

	if self._align == Container.Align.Stretch then
		self:eachVisibleChild(function(child)
			local size = child:getSize():multiply(self._dir)
			child:setSize(size + self:_normalDir():multiply(childrenSize))
		end)
	end

	local containerSize = self:getSize():multiply(self._dir)
	local currentSize = childrenSize:multiply(self._dir)


	if containerSize:len() > currentSize:len() and #growChildren > 0 then
		local remainingSpace = containerSize:len() - currentSize:len()
		local size = remainingSpace / #growChildren

		for _, child in ipairs(growChildren) do
			local remainingChildSize = child:getSize():multiply(self:_normalDir())
			child:setSize(child:getSize() + remainingChildSize + self._dir * size)
		end
	end


	Container.super.setSize(self, childrenSize)
end

function Container:__tostring()
	return 'Container(dir=' .. tostring(self._dir) .. ',#children=' .. #self:getChildren() .. ')'
end

return Container
