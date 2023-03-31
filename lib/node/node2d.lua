local Node = require 'lib.node'
local Node2D = Node:extend()

function Node2D:new(pos)
	Node2D.super.new(self)
	self._pos = pos or Vector.ZERO
	self._rotation = 0
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
		love.graphics.push()
		love.graphics.rotate(self:getGlobalRotation())
		Node2D.super.draw(self)
		love.graphics.pop()
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

function Node2D:setRotation(angle)
	self._rotation = angle
end

function Node2D:getRotation()
	return self._rotation
end

function Node2D:getGlobalRotation()
	local rotation = self._rotation
	if self._parent and self._parent:is(Node2D) then
		rotation = rotation + self._parent:getGlobalRotation()
	end

	return rotation
end

return Node2D
