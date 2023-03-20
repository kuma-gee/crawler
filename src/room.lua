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
	local room_pos = Vector(self.pos.x * size.x, self.pos.y * size.y)

	if active_pos == self.pos then
		love.graphics.setColor(255, 0, 0, 255)
	else
		love.graphics.setColor(255, 255, 255, 255)
	end

	love.graphics.rectangle('line', room_pos.x, room_pos.y, size.x, size.y)

	local center = room_pos + size / 2
	for _, door in pairs(self.doors) do
		love.graphics.setColor(0, 255, 0, 255)

		local door_pos = center + Vector(door.x * size.x / 2, door.y * size.y / 2)
		love.graphics.circle('fill', door_pos.x, door_pos.y, 2)
	end
end

return Room
