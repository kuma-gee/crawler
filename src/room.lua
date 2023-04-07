local Room = Class:extend()

local dir_to_letter = {
	[Vector.LEFT] = 'W',
	[Vector.RIGHT] = 'E',
	[Vector.UP] = 'N',
}

local letter_to_image = {
	['N'] = love.graphics.newImage('assets/Walls_N_0.png', {}),
	['E'] = love.graphics.newImage('assets/Walls_E_0.png', {}),
	['W'] = love.graphics.newImage('assets/Walls_W_0.png', {}),
	[''] = love.graphics.newImage('assets/Walls_S_0.png', {}),
	['NW'] = love.graphics.newImage('assets/Walls_NW_0.png', {}),
	['EN'] = love.graphics.newImage('assets/Walls_NE_0.png', {}),
	['ENW'] = love.graphics.newImage('assets/Walls_NEW_0.png', {}),
	['EW'] = love.graphics.newImage('assets/Walls_EW_0.png', {}),
}

function Room:new(p, d)
	self.pos = p
	self.doors = d
	self._items = {}
	self._enemy = nil
	self._exit = false
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

	local w, h = Unit.w(1), Unit.h(1)
	local scaleX = w / background:getWidth()
	local scaleY = h / background:getHeight()
	love.graphics.draw(background, love.math.newTransform(0, 0, 0, scaleX, scaleY))

	local enemy = self:getEnemy()
	if enemy ~= nil then
		enemy:draw()
	end
end

function Room:_getBackground()
	local letters = {}

	for k, v in pairs(dir_to_letter) do
		if self:canMove(k) then
			table.insert(letters, v)
		end
	end

	table.sort(letters)
	return letter_to_image[table.concat(letters)]
end

function Room:addItem(item)
	table.insert(self._items, item)
end

function Room:setEnemy(enemy)
	self._enemy = enemy
	if enemy ~= nil then
		enemy:load()
		enemy.onDied:register(function()
			self._enemy = nil
		end)
	end
end

function Room:setExit()
	self._exit = true
end

function Room:isExit()
	return self._exit
end

function Room:getEnemy()
	return self._enemy
end

function Room:getItems()
	return self._items
end

function Room:removeItem(item)
	for i, v in ipairs(self._items) do
		if v == item then
			table.remove(self._items, i)
		end
	end
end

return Room
