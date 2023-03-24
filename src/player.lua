local Node2D = require 'lib.node.node2d'
local KeyEvent = require 'lib.input.key-event'
local Player = Node2D:extend()

function Player:new()
	Player.super.new(self)
	self.onMove = Signal()

	self._health = 5
end

function Player:input(ev)
	if ev:is(KeyEvent) and ev:isPressed() then
		local key = ev:getKey()
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
end

return Player
