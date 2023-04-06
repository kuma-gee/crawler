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
		self:drawLocal()
		Node2D.super.draw(self)
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
		transform:apply(self._parent:getLocalTransform())
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

-- function Node2D:setGlobalPosition(pos)
-- 	local transform = self:getGlobalTransform()
-- 	local r = self:_getRotationOfTransform(transform)

-- 	-- if r ~= 0 then
-- 	-- 	transform:rotate(r)
-- 	-- end

-- 	local targetLocalPos = Vector(transform:inverseTransformPoint(pos.x, pos.y))
-- 	-- print(self:getTransform():inverseTransformPoint(pos.x, pos.y))
-- 	-- self._transform:translate(rel.x, rel.y)
-- 	print(targetLocalPos)
-- 	self:setPosition(targetLocalPos)
-- 	return self
-- end

function Node2D:getGlobalPosition()
	local origin = self:getGlobalTransform()
	return Vector(origin:transformPoint(0, 0))
end

-- function Node2D:setRotation(angle)
-- 	local r = self:getRotation()
-- 	local diff = r - angle
-- 	print(diff)
-- 	self._transform:rotate(diff)
-- end

-- function Node2D:getRotation()
-- 	return self:_getRotationOfTransform(self:getLocalTransform()) % math.tau
-- end

-- function Node2D:_getRotationOfTransform(transform)
-- 	local dir = Vector.UP
-- 	local pos = Vector(transform:transformPoint(0, 0))
-- 	local dirPos = Vector(transform:transformPoint(dir:value()))
-- 	local localDir = dirPos - pos
-- 	return localDir:angleTo(dir)
-- end

return Node2D
