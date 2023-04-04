local Node = require 'lib.node'
local Node2D = Node:extend()

function Node2D:new(pos)
	Node2D.super.new(self)
	self._transform = love.math.newTransform()
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
		love.graphics.applyTransform(self._transform)
		Node2D.super.draw(self)
		self:drawLocal()
		love.graphics.pop()
	end
end

function Node2D:drawLocal()
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

function Node2D:getOriginTransform()
	local transform = love.math.newTransform()
	if self._parent and self._parent:is(Node2D) then
		transform:apply(self._parent:getOriginTransform())
		transform:apply(self._parent:getTransform())
	end

	return transform
end

function Node2D:getGlobalTransform()
	local transform = self:getOriginTransform()
	transform:apply(self:getLocalTransform())
	return transform
end

function Node2D:getLocalTransform()
	return self._transform
end

function Node2D:getPosition(p)
	local pos = p or Vector.ZERO
	return Vector(self:getLocalTransform():transformPoint(pos.x, pos.y))
end

function Node2D:setPosition(pos)
	local curr = self:getPosition()
	local rel = pos - curr
	-- local dir = rel:rotated(math.tau - self:getRotation())

	self._transform:translate(rel.x, rel.y)
	return self
end

function Node2D:setGlobalPosition(pos)
	local origin = self:getOriginTransform()
	local rel = Vector(origin:inverseTransformPoint(pos.x, pos.y))
	-- print(self:getTransform():inverseTransformPoint(pos.x, pos.y))
	-- self._transform:translate(rel.x, rel.y)
	self:setPosition(rel)
	return self
end

function Node2D:getGlobalPosition()
	local origin = self:getGlobalTransform()
	return Vector(origin:transformPoint(0, 0))
end

function Node2D:setRotation(angle)
	local r = self:getRotation()
	local diff = r - angle
	self._transform:rotate(diff)
end

function Node2D:getRotation()
	local pos = self:getPosition()
	local up = self:getPosition(Vector.UP)
	local dir = (up - pos)
	return Vector.UP:angleTo(dir)
end

-- function Node2D:getRotation()
-- 	return self._rotation
-- end

-- function Node2D:getGlobalRotation()
-- 	local rotation = self._rotation
-- 	if self._parent and self._parent:is(Node2D) then
-- 		rotation = rotation + self._parent:getGlobalRotation()
-- 	end

-- 	return rotation
-- end

return Node2D
