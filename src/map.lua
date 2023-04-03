local Control = require 'lib.node.control'
local Map = Control:extend()

local activeColor = { 0, 1, 0, 1 }
local lootColor = { 0, 0, 1, 1 }
local enemyColor = { 1, 0, 0, 1 }

local wallColor = { 1, 1, 1, 1 }
local floorColor = { 1, 1, 1, 0.3 }

local roomSize = 15

function Map:new(dungeon)
	Map.super.new(self)
	self._dungeon = dungeon
	self:setRotation(1)
end

function Map:load()
	roomSize = math.floor(Unit.w(0.03))
end

function Map:toWorld(v)
	return v * roomSize
end

function Map:_drawRoom(room, pos)
	love.graphics.setLineWidth(1)

	local lines = {}
	local topLeft = pos + Vector.TOP_LEFT * roomSize / 2
	local botRight = pos + Vector.BOT_RIGHT * roomSize / 2
	if not room:canMove(Vector.UP) then
		table.insert(lines, { topLeft, topLeft + self:toWorld(Vector.RIGHT) })
	end
	if not room:canMove(Vector.LEFT) then
		table.insert(lines, { topLeft, topLeft + self:toWorld(Vector.DOWN) })
	end
	if not room:canMove(Vector.DOWN) then
		table.insert(lines, { botRight, botRight + self:toWorld(Vector.LEFT) })
	end
	if not room:canMove(Vector.RIGHT) then
		table.insert(lines, { botRight, botRight + self:toWorld(Vector.UP) })
	end

	self:drawInColor(floorColor, function()
		love.graphics.rectangle('fill', topLeft.x, topLeft.y, roomSize, roomSize)
	end)

	self:drawInColor(wallColor, function()
		for _, points in ipairs(lines) do
			local p1 = points[1]
			local p2 = points[2]

			love.graphics.line(p1.x, p1.y, p2.x, p2.y)
		end
	end)
end

function Map:_drawEvents(room, center, isActive)
	if isActive then
		self:drawInColor(activeColor, function()
			love.graphics.points(center.x, center.y)
		end)
	else
		if room:getEnemy() then
			self:drawInColor(enemyColor, function()
				love.graphics.points(center.x, center.y)
			end)
		elseif #room:getItems() > 0 then
			self:drawInColor(lootColor, function()
				love.graphics.points(center.x, center.y)
			end)
		end
	end
end

function Map:draw()
	local playerPos = self._dungeon.pos
	local mapCenter = self:getCenter()
	local start = self:getTopLeftCorner()
	local size = self:getSize()

	love.graphics.stencil(function() love.graphics.rectangle('fill', start.x, start.y, size.x, size.y) end, "replace", 1)
	love.graphics.setStencilTest("greater", 0)

	for x, row in pairs(self._dungeon:getMap()) do
		for y, room in pairs(row) do
			local localPosFromCenter = Vector(x, y) - playerPos
			local posFromCenter = self:toWorld(localPosFromCenter)

			local roomCenter = mapCenter + posFromCenter
			self:_drawRoom(room, roomCenter)

			local isActive = playerPos == Vector(x, y)
			self:_drawEvents(room, roomCenter, isActive)
		end
	end

	love.graphics.setStencilTest()
	Map.super.draw(self)
end

function Map:update(_)
	-- Map.super.update(_)

	-- self:setRotation(0.1)

	-- print(self._transform:transformPoint(192, 108))
end

return Map
