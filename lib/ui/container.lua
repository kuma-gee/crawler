local Widget = require 'lib.ui.widget'
local Container = Widget:extend({
	_dir = Vector.DOWN,
	_children = {},
	_logger = Logger.new('Container'),
	_bgColor = { 0, 0, 0, 0 },
})

function Container:constructor(dir)
	self._dir = dir
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
	local currPos = self:getInnerTopLeftCorner()

	print(self._children)

	for _, child in ipairs(self._children) do
		child:setTopLeftCorner(currPos:clone())
		child:update()

		local childSize = child:getOuterSize()
		currPos = currPos + childSize:permul(self._dir)
		size = size + childSize:permul(self._dir:abs())
		if self._dir * Vector.UP == 0 then
			size.y = math.max(size.y, childSize.y)
		else
			size.x = math.max(size.x, childSize.x)
		end
	end

	self:setInnerSize(size)
end

function Container:draw()
	local pos = self:getTopLeftCorner()
	local size = self:getOuterSize()

	self:drawInColor(self._bgColor, function()
		love.graphics.rectangle("fill", pos.x, pos.y, size.x, size.y)
	end)

	for _, child in ipairs(self._children) do
		child:draw()
	end
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
	if theme.background then
		self._bgColor = theme.background
	end
	return Widget.setTheme(self, theme)
end

return Container
