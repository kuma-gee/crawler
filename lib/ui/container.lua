local Widget = require 'lib.ui.widget'
local Container = setmetatable({ children = {} }, { __index = Widget })
Container.__index = Container

local Direction = { ROW = 'row', COL = 'col' }

function Container.new()
	return setmetatable({ _dir = Direction.COL }, Container)
end

function Container:addChild(child)
	table.insert(self.children, child)
	return self
end

function Container:setDirection(dir)
	self._dir = dir
end

function Container:update()
	local size = Vector(0, 0)
	local currPos = self:getTopLeftCorner():clone()

	for _, child in ipairs(self.children) do
		child:setTopLeftCorner(currPos:clone())
		child:update()

		local childSize = child:getOuterSize()

		if self._dir == Direction.ROW then
			size.y = math.max(size.y, childSize.y)
			size.x = currPos.y + childSize.x
			currPos.x = size.x
		else
			size.x = math.max(size.x, childSize.x)
			size.y = currPos.y + childSize.y
			currPos.y = size.y
		end
	end

	self:setInnerSize(size)
end

function Container:draw()
	for _, child in ipairs(self.children) do
		child:draw()
	end
end

function Container:mousepressed(...)
	for _, child in ipairs(self.children) do
		child:mousepressed(...)
	end
end

function Container:mousereleased(...)
	for _, child in ipairs(self.children) do
		child:mousereleased(...)
	end
end

return setmetatable({ Direction = Direction }, Container)
