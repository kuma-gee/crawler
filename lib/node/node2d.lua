local Node = require 'lib.node'
local Node2D = Node:extend()

function Node2D:new(pos)
	Node2D.super.new(self)
	self._pos = pos or Vector.ZERO
	self._visible = true
end

function Node2D:hide()
	self._visible = false
end

function Node2D:show()
	self._visible = true
end

function Node2D:isVisible()
	return self._visible
end

function Node2D:draw()
	if self._visible then
		Node2D.super.draw(self)
	end
end

function Node2D:update(_)
	if self._visible then
		Node2D.super.update(self, _)
	end
end

function Node:eachVisibleChild(fn)
	for _, child in ipairs(self:getChildren() or {}) do
		if child:isVisible() then
			fn(child)
		end
	end
end

function Node2D:setPosition(pos)
	self._pos = pos
	return self
end

function Node2D:getPosition()
	return self._pos:clone()
end

function Node2D:getGlobalPosition()
	local root = Vector.ZERO
	if self._parent and self._parent:is(Node2D) then
		root = self._parent:getGlobalPosition()
	end
	return root + self._pos
end

return Node2D
