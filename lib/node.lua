local Node = Class:extend()

local function indexOf(coll, item)
	for i, x in ipairs(coll) do
		if x == item then
			return i
		end
	end
	return -1
end

function Node:new()
	self._children = {}
	self._parent = nil
end

function Node:getParent()
	return self._parent
end

function Node:getChildren()
	return self._children
end

function Node:addChild(...)
	for i = 1, select('#', ...) do
		local child = select(i, ...)
		table.insert(self._children, child)
		child._parent = self
	end

	return self
end

function Node:removeChild(child)
	local toRemove = indexOf(self._children, child)
	if toRemove ~= -1 then
		table.remove(self._children, toRemove)
	end
end

function Node:clearChildren()
	self._children = {}
end

function Node:eachChild(fn)
	for _, child in ipairs(self:getChildren() or {}) do
		fn(child)
	end
end

function Node:load()
	self:eachChild(function(child)
		child:load()
	end)
end

function Node:update(dt)
	self:eachChild(function(child)
		child:update(dt)
	end)
end

function Node:draw()
	self:eachChild(function(child)
		child:draw()
	end)
end

function Node:input(ev)
	self:eachChild(function(child)
		child:input(ev)
	end)
end

return Node
