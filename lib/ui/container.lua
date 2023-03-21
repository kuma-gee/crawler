local Widget = require 'lib.ui.widget'
local Container = setmetatable({}, { __index = Widget.new() })
Container.__index = Container

local Direction = { ROW = 'row', COL = 'col' }
local Align = {}

function Container.new(dir)
	return setmetatable({ _dir = dir or Direction.COL, _children = {}, _logger = Logger.new('Container') }, Container)
end

function Container:addChild(child)
	table.insert(self._children, child)
	return self
end

function Container:setDirection(dir)
	self._dir = dir
end

function Container:update()
	local size = Vector(0, 0)
	local currPos = self:getInnerTopLeftCorner():clone()

	for _, child in ipairs(self._children) do
		child:setTopLeftCorner(currPos:clone())
		child:update()

		local childSize = child:getOuterSize()

		if self._dir == Direction.ROW then
			size.y = math.max(size.y, childSize.y)
			size.x = size.x + childSize.x
			currPos.x = currPos.x + childSize.x
		else
			size.x = math.max(size.x, childSize.x)
			size.y = size.y + childSize.y
			currPos.y = currPos.y + childSize.y
		end

		self._logger:info(currPos)
	end

	self:setInnerSize(size)
end

function Container:draw()
	for _, child in ipairs(self._children) do
		child:draw()
	end

	Widget.draw(self)
end

function Container:mousepressed(...)
	for _, child in ipairs(self._children) do
		child:mousepressed(...)
	end
end

function Container:mousereleased(...)
	for _, child in ipairs(self._children) do
		child:mousereleased(...)
	end
end

function Container:setTheme(theme)
	return Widget.setTheme(self, theme)
end

return setmetatable({ Dir = Direction }, Container)
