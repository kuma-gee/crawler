local Node2D = require 'lib.node.node2d'
local KeyEvent = require 'lib.input.key-event'
local Player = Node2D:extend()

function Player:new()
	Player.super.new(self)
	self.onMove = Signal()
	self.onHealthChange = Signal()
	self.onInventoryChange = Signal()

	self._max_health = 10
	self._health = self._max_health
	self._inventory = {}
end

function Player:load()
	self:_emitCurrentHealth()
end

function Player:hurt(dmg)
	self._health = self._health - dmg
	self:_emitCurrentHealth()
end

function Player:_emitCurrentHealth()
	self.onHealthChange:emit(self._health, self._max_health)
end

function Player:disableInput()
	self._disableInput = true
end

function Player:enableInput()
	self._disableInput = false
end

function Player:input(ev)
	if self._disableInput then
		return
	end

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

function Player:getInventory()
	return self._inventory
end

function Player:addItem(item)
	table.insert(self._inventory, item)
	self.onInventoryChange:emit(self._inventory)
end

function Player:getWeapons()
	local weapons = {}
	for _, v in ipairs(self._inventory) do
		if table.contains(Weapon, v) then
			table.insert(weapons, v)
		end
	end

	return weapons
end

return Player
