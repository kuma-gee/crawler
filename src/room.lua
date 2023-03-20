local Room = {}
Room.__index = Room

local dir_to_letter = {
	[Vector.DOWN] = 'S',
	[Vector.LEFT] = 'W',
	[Vector.RIGHT] = 'E',
	[Vector.UP] = 'N',
}

local letter_to_image = {
	['N'] = love.graphics.newImage('assets/Walls_N_0.png', {}),
	['E'] = love.graphics.newImage('assets/Walls_E_0.png', {}),
	['W'] = love.graphics.newImage('assets/Walls_W_0.png', {}),
	['S'] = love.graphics.newImage('assets/Walls_S_0.png', {}),
	['NW'] = love.graphics.newImage('assets/Walls_NW_0.png', {}),
	['NE'] = love.graphics.newImage('assets/Walls_NE_0.png', {}),
	['NEW'] = love.graphics.newImage('assets/Walls_NEW_0.png', {}),
	['EW'] = love.graphics.newImage('assets/Walls_EW_0.png', {}),
}

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

function Room:draw()
	local background = self:_getBackground()

	local scaleX = love.graphics.getWidth() / background:getWidth()
	local scaleY = love.graphics.getHeight() / background:getHeight()
	love.graphics.draw(background, love.math.newTransform(0, 0, 0, scaleX, scaleY))
end

function Room:_getBackground()
	local letters = ''

	for k, v in pairs(dir_to_letter) do
		if self:canMove(k) then
			letters = letters .. v
		end
	end

	if string.len(letters) > 1 and string.find(letters, 'S') then
		letters = string.gsub(letters, 'S', '')
	end


	return letter_to_image[letters]
end

function Room:draw_map(active_pos, size, offset)
	local function to_world(v)
		return v:permul(size)
	end

	local pos = to_world(self.pos) + offset
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

	love.graphics.setColor(1, 1, 1, 0.3)
	love.graphics.rectangle('fill', pos.x, pos.y, size.x, size.y)

	love.graphics.setColor(1, 1, 1, 1)
	for _, points in ipairs(lines) do
		local p1 = points[1]
		local p2 = points[2]
		love.graphics.line(p1.x, p1.y, p2.x, p2.y)
	end

	if active_pos == self.pos then
		local center = pos + size / 2
		love.graphics.setColor(0, 1, 0, 1)
		love.graphics.circle('fill', center.x, center.y, 2)
	end
end

return Room
