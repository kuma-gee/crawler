local Control = require 'lib.node.control'
local Container = Control:extend()

local Align = { Start = 'start', Center = 'center', End = 'end', Stretch = 'stretch' }

function Container:new(dir, anchor)
	Container.super.new(self, anchor)
	-- self._pad = { 0, 0, 0, 0 }
	self._dir = dir or Vector.DOWN
	self._logger = Logger.new('Container')
	self._align = Align.Start
end

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

-- function Container:setSize(size)
-- 	self._logger:warn("Setting container size is not supported.")
-- 	return self
-- end

-- function Container:getSize()
-- 	local size = Container.super.getSize(self)
-- 	return Vector(
-- 		size.x + self:_getLeftPadding() + self:_getRightPadding(),
-- 		size.y + self:_getTopPadding() + self:_getBottomPadding()
-- 	);
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

function Container:_getInnerTopLeftCorner()
	return self:getTopLeftCorner() -- + self:_topLeftPadding()
end

-- function Container:_topLeftPadding()
-- 	return Vector(self:_getLeftPadding(), self:_getTopPadding())
-- end

-- function Container:_bottomRightPadding()
-- 	return Vector(self:_getRightPadding(), self:_getBottomPadding())
-- end

function Container:update(_)
	self:_updateSize()

	local currPos = self:_getInnerTopLeftCorner()
	self:eachVisibleChild(function(child)
		child:setPosition(currPos:clone())
		currPos = currPos + child:getSize():multiply(self._dir)
	end)
end

function Container:_updateSize()
	local childrenSize = Vector(0, 0)
	local growChildren = {}
	self:eachVisibleChild(function(child)
		child:update()

		local childSize = child:getSize()
		childrenSize = childrenSize + childSize:multiply(self._dir:abs())

		if self._dir * Vector.UP == 0 then
			childrenSize.y = math.max(childrenSize.y, childSize.y)
		else
			childrenSize.x = math.max(childrenSize.x, childSize.x)
		end

		if child:isGrow() then
			table.insert(growChildren, child)
		end
	end)

	local containerSize = self:getSize():multiply(self._dir)
	local currentSize = childrenSize:multiply(self._dir)

	if containerSize:len() > currentSize:len() and #growChildren > 0 then
		local remainingSpace = containerSize:len() - currentSize:len()
		local size = remainingSpace / #growChildren
		for _, child in ipairs(growChildren) do
			local childSizeWithoutDirSize = child:getSize():multiply(self._dir:perpendicular():abs())
			child:setSize(childSizeWithoutDirSize + self._dir * size)
		end
	end


	Container.super.setSize(self, childrenSize) --+ self:_topLeftPadding() + self:_bottomRightPadding())
end

function Container:setTheme(theme)
	-- if theme.padding then
	-- 	self:setPadding(theme.padding)
	-- end

	return Container.super.setTheme(self, theme)
end

return Container
