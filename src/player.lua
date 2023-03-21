local Player = {}
Player.__index = Player

function Player.new()
	return setmetatable({ onMove = Signal() }, Player)
end

function Player:keypressed(key)
	if key == "up" then
		self.onMove:emit(Vector(0, -1))
	elseif key == "down" then
		self.onMove:emit(Vector(0, 1))
	elseif key == "left" then
		self.onMove:emit(Vector(-1, 0))
	elseif key == "right" then
		self.onMove:emit(Vector(1, 0))
	end
end

local default = Player.new()

return default
