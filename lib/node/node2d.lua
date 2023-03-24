local Node = require 'lib.node'
local Node2D = Node:extend()

function Node2D:new(pos)
	Node2D.super.new(self)
	self._pos = pos or Vector.ZERO
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
