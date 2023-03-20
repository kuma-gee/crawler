local Room = {}
Room.__index = Room

function Room.new(p, d)
	return setmetatable({ pos = p, doors = d }, Room)
end

function Room:canMove(dir)
	for _, d in ipairs(self.doors) do
		if d == dir then
			return true
		end
	end

	return false
end

function Room:draw(active_pos)
	local size = Vector(50, 50)
	local function to_world(v)
		return Vector(v.x * size.x, v.y * size.y)
	end


	local pos = to_world(self.pos)
	local lines = {}
	if not self:canMove(Vector.UP) then
		table.insert(lines, { pos, pos + to_world(Vector.RIGHT) })
	end
	if not self:canMove(Vector.LEFT) then
		table.insert(lines, { pos, pos + to_world(Vector.DOWN) })
	end
	if not self:canMove(Vector.DOWN) then
		table.insert(lines, { pos + to_world(Vector.DOWN), pos + to_world(Vector.DOWN + Vector.RIGHT) })
	end
	if not self:canMove(Vector.RIGHT) then
		table.insert(lines, { pos + to_world(Vector.RIGHT), pos + to_world(Vector.DOWN + Vector.RIGHT) })
	end

	love.graphics.setColor(255, 255, 255, 255)
	for _, points in ipairs(lines) do
		local p1 = points[1]
		local p2 = points[2]
		love.graphics.line(p1.x, p1.y, p2.x, p2.y)
	end

	if active_pos == self.pos then
		local center = pos + size / 2
		love.graphics.setColor(0, 255, 0, 255)
		love.graphics.circle('fill', center.x, center.y, 2)
	end
end

return Room
