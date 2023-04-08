local Control = require 'lib.node.control'
local Container = Control:extend()

-- Container.Align = { Start = 'start', Center = 'center', End = 'end', Stretch = 'stretch' }

function Container:new(dir, anchor)
	Container.super.new(self, anchor)
	self._dir = (dir or Vector.DOWN):abs():normalizedInGrid()
	self._fixedSize = Vector.ZERO
	-- self._logger = Logger.new('Container')
	-- self._align = align or Container.Align.Start
end

function Container:setSize(size)
	self._fixedSize = size
	return self
end

-- function Container:_getInnerTopLeftCorner()
-- 	return self:getTopLeftCorner()
-- end

-- function Container:_getTopPadding()
-- 	return self._pad[1]
-- end

-- function Container:_getRightPadding()
-- 	return self._pad[2]
-- end

-- function Container:_getBottomPadding()
-- 	return self._pad[3]
-- end

-- function Container:_getLeftPadding()
-- 	return self._pad[4]
-- end

-- function Container:setPadding(v)
-- 	if type(v) == 'table' then
-- 		if #v >= 4 then
-- 			self._pad = { v[1], v[2], v[3], v[4] }
-- 		elseif #v >= 2 then
-- 			self._pad = { v[1], v[2], v[1], v[2] }
-- 		else
-- 			self._pad = { v[1], v[1], v[1], v[1] }
-- 		end
-- 	elseif not (v == nil) then
-- 		self._pad = { v, v, v, v }
-- 	end

-- 	return self
-- end

function Container:update(_)
	self:_updateSize()

	local currPos = self:getTopLeftCorner()

	self:eachVisibleChild(function(child)
		child:setPosition(currPos) --self:_getPositionForAlignment(currPos, child))
		currPos = currPos + child:getSize():multiply(self._dir)
	end)
end

-- function Container:_getPositionForAlignment(pos, child)
-- 	local dir = self:_normalDir()
-- 	if self._align == Container.Align.Center then
-- 		local center = pos + self:getSize():multiply(dir / 2)
-- 		return center - child:getSize():multiply(dir / 2)
-- 	elseif self._align == Container.Align.End then
-- 		local endPos = pos + self:getSize():multiply(dir)
-- 		return endPos - child:getSize():multiply(dir)
-- 	end

-- 	return pos:clone()
-- end

-- function Container:_normalDir()
-- 	return self._dir:perpendicular():abs()
-- end

function Container:getSize()
	local size = Container.super.getSize(self)
	if self._fixedSize ~= Vector.ZERO then
		return self._fixedSize:max(size)
	end

	return size
end

function Container:_updateSize()
	local childrenSize = Vector(0, 0)
	-- local growChildren = {}

	local containerSizeInDir = self._fixedSize:multiply(self._dir)
	local perpendicularDir = self._dir:perpendicular():abs()

	self:eachVisibleChild(function(child)
		child:update()

		local childSize = child:getSize()
		local growDir = childSize:multiply(self._dir)

		if self._fixedSize ~= Vector.ZERO and growDir:len2() > containerSizeInDir:len2() then
			growDir = containerSizeInDir
			child:setSize(childSize:multiply(perpendicularDir) + growDir)
			childSize = child:getSize()
		end

		childrenSize = childrenSize + growDir

		local isHorizontal = self._dir * Vector.UP == 0
		if isHorizontal then
			childrenSize.y = math.max(childrenSize.y, childSize.y)
		else
			childrenSize.x = math.max(childrenSize.x, childSize.x)
		end

		-- if child:isGrow() then
		-- 	table.insert(growChildren, child)
		-- end
	end)

	-- if self._align == Container.Align.Stretch then
	-- 	self:eachVisibleChild(function(child)
	-- 		local size = child:getSize():multiply(self._dir)
	-- 		child:setSize(size + self:_normalDir():multiply(childrenSize))
	-- 	end)
	-- end

	-- local containerSize = self:getSize():multiply(self._dir)
	-- local currentSize = childrenSize:multiply(self._dir)

	-- if containerSize:len() > currentSize:len() and #growChildren > 0 then
	-- 	local remainingSpace = containerSize:len() - currentSize:len()
	-- 	local size = remainingSpace / #growChildren

	-- 	for _, child in ipairs(growChildren) do
	-- 		local remainingChildSize = child:getSize():multiply(self:_normalDir())
	-- 		child:setSize(child:getSize() + remainingChildSize + self._dir * size)
	-- 	end
	-- end

	Container.super.setSize(self, self._fixedSize:max(childrenSize))
end

function Container:__tostring()
	return 'Container(dir=' .. tostring(self._dir) .. ',#children=' .. #self:getChildren() .. ')'
end

return Container
