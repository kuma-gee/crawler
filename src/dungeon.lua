local Room = require 'src.room'

local Dungeon = {}
Dungeon.__index = Dungeon

local move_dirs = { Vector.UP, Vector.DOWN, Vector.LEFT, Vector.RIGHT }

local function _randomStart(x, y)
	return Vector(math.random(1, x), math.random(1, y))
end

function Dungeon.new(w, h)
	local dungeon = setmetatable({ size = Vector(w, h), pos = _randomStart(w, h), map = {} }, Dungeon)

	for x = 1, w do
		dungeon.map[x] = {}

		for y = 1, h do
			dungeon.map[x][y] = nil
		end
	end

	dungeon:move(Vector.ZERO)

	return dungeon
end

function Dungeon:move(dir)
	local curr_room = self:activeRoom()

	if curr_room == nil or curr_room:canMove(dir) then
		local new_pos = self.pos + dir
		if self:_isInside(new_pos) then
			self.pos = new_pos

			local new_room = self:activeRoom()
			if new_room == nil then
				self:_generateRoom(-dir)
			end
		end
	end
end

function Dungeon:activeRoom()
	return self:_getRoom(self.pos)
end

function Dungeon:_getRoom(pos)
	return self.map[pos.x][pos.y]
end

function Dungeon:_generateRoom(initial_dir)
	local possible, initial = self:_calcDirections(initial_dir)
	local doors = initial

	for _ = 1, math.random(2) do
		local idx = math.random(#possible)
		local dir = table.remove(possible, idx)
		table.insert(doors, dir)
	end


	self.map[self.pos.x][self.pos.y] = Room.new(self.pos, doors)
end

function Dungeon:_calcDirections(init_dir)
	local result = {}
	local initial = {}

	if not (init_dir == Vector.ZERO) then
		table.insert(initial, init_dir)
	end

	for _, dir in ipairs(move_dirs) do
		local neighbor = self.pos + dir
		if self:_isInside(neighbor) and not (dir == init_dir) then
			local room = self:_getRoom(neighbor)

			if room == nil then
				table.insert(result, dir)
			elseif room:canMove(-dir) then
				table.insert(initial, dir)
			end
		end
	end

	return result, initial
end

function Dungeon:_isInside(pos)
	return pos.x >= 1 and pos.x <= self.size.x
		and pos.y >= 1 and pos.y <= self.size.y
end

function Dungeon:draw()
	for _, row in pairs(self.map) do
		for _, col in pairs(row) do
			col:draw()
			local size = Vector(10, 10)
			local offset = Vector(love.graphics.getWidth(), love.graphics.getHeight()) - self.size:permul(size + Vector(1, 1))
			col:draw_map(self.pos, size, offset)
		end
	end
end

local default = Dungeon.new(10, 10)

return default
