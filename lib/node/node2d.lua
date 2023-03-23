local Node = require 'lib.node'
local Node2D = Node:extend()

function Node2D:new()
	Node2D.super.new(self)
	self._pos = Vector.ZERO
end

function Node2D:setPosition(pos)
	self._pos = pos
end

function Node2D:getPosition()
	return self._pos:clone()
end

function Node2D:getGlobalPosition()
	local root = Vector.ZERO
	if self._parent then
		root = self._parent:getGlobalPosition()
	end
	return root + self._pos
end

return Node2D
