local Player = {}
Player.__index = Player

function Player.new()
	return setmetatable({ move = Signal.new() }, Player)
end

function Player:keypressed(key)
	if key == "up" then
		self.move:emit(Vector(0, -1))
	elseif key == "down" then
		self.move:emit(Vector(0, 1))
	elseif key == "left" then
		self.move:emit(Vector(-1, 0))
	elseif key == "right" then
		self.move:emit(Vector(1, 0))
	end
end

return Player.new()
