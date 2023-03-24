local Control = require 'lib.node.control'
local Map = Control:extend()

function Map:new(dungeon)
	Map.super.new(self)
	self._dungeon = dungeon
	self:setSize(Vector(100, 100))
end

function Map:toWorld(v, size)
	return v:multiply(size)
end

function Map:draw()
	local roomSize = self:getSize():divide(self._dungeon:getSize())

	for x, row in pairs(self._dungeon:getMap()) do
		for y, room in pairs(row) do
			local roomPos = Vector(x, y)
			local pos = self:getTopLeftCorner() + self:toWorld(roomPos - Vector(1, 1), roomSize)
			local lines = {}
			if not room:canMove(Vector.UP) then
				table.insert(lines, { pos, pos + self:toWorld(Vector.RIGHT, roomSize) })
			end
			if not room:canMove(Vector.LEFT) then
				table.insert(lines, { pos, pos + self:toWorld(Vector.DOWN, roomSize) })
			end
			if not room:canMove(Vector.DOWN) then
				table.insert(lines, { pos + self:toWorld(Vector.DOWN, roomSize), pos + self:toWorld(Vector.BOT_RIGHT, roomSize) })
			end
			if not room:canMove(Vector.RIGHT) then
				table.insert(lines, { pos + self:toWorld(Vector.RIGHT, roomSize), pos + self:toWorld(Vector.BOT_RIGHT, roomSize) })
			end

			self:drawInColor({ 1, 1, 1, 0.3 }, function()
				love.graphics.rectangle('fill', pos.x, pos.y, roomSize.x, roomSize.y)
			end)

			self:drawInColor({ 1, 1, 1, 1 }, function()
				for _, points in ipairs(lines) do
					local p1 = points[1]
					local p2 = points[2]
					love.graphics.line(p1.x, p1.y, p2.x, p2.y)
				end
			end)

			local isActive = self._dungeon.pos == roomPos
			if isActive then
				local center = pos + roomSize / 2
				self:drawInColor({ 0, 1, 0, 1 }, function()
					love.graphics.circle('fill', center.x, center.y, 2)
				end)
			end
		end
	end
end

return Map
