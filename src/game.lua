local Player = require "src.player"
local Dungeon = require 'src.dungeon'
local MainContainer = require 'src.main-container'
local Enemy = require 'src.enemy'
local Timer = require 'lib.timer'

local Node = require 'lib.node'
local Game = Node:extend()

Events = { Enemy = 'enemy', NPC = 'npc', Loot = 'loot', Exit = 'exit', Nothing = 'nothing' }
Enemy = { Bat = 'bat', Goblin = 'goblin', Skeleton = 'skeleton' }
Weapon = { Sword = 'sword', Knife = 'Knife', Stone = 'stone' }
Loot = { Torch = 'torch', Armor = 'armor', unpack(Weapon) }

local foundExit = false
local spawnedTorch = false

local weapon_dmg = {
	[Weapon.Sword] = 6,
	[Weapon.Knife] = 3,
	[Weapon.Stone] = 1,
}

local event_values = {
	[Events.Enemy] = 0,
	[Events.Loot] = 0,
	[Events.Exit] = 0,
	[Events.Nothing] = 800,
}

local loot_values = {
	{ Loot.Torch, 100 },
	{ Loot.Knife, 20 },
	{ Loot.Armor, 40 },
	{ Loot.Sword, 50 },
}

local enemy_values = {
	{ Enemy.Bat,      100 },
	{ Enemy.Goblin,   20 },
	{ Enemy.Skeleton, 100 },
}

local function _randomItem(items)
	local rand = math.random(0, 100)

	for _, v in pairs(items) do
		if rand <= v[2] then
			return v[1]
		end
	end

	return nil
end

local function _totalEventValue()
	local total = 0
	local accum = {}

	for ev, v in pairs(event_values) do
		local x = total + v
		table.insert(accum, { ev, x })
		total = x
	end

	return accum, total
end

local function _increaseEvent(ev, value)
	event_values[ev] = event_values[ev] + value
end

local function _resetEvent(ev)
	event_values[ev] = 0
end

function Game:_randomEvent()
	if self.dungeon:getDiscoveredPercentage() > 0.8 then
		return Events.Exit
	end

	local values, total = _totalEventValue()
	local rand = math.random(0, total)

	for _, v in pairs(values) do
		if rand <= v[2] then
			return v[1]
		end
	end

	return Events.Nothing
end

function Game:_updateEventChances(ev)
	if not foundExit then
		event_values[Events.Exit] = self.dungeon:getDiscoveredPercentage() * 100
	else
		event_values[Events.Exit] = 0
	end

	local items = self.player:getInventory()

	if #items == 0 and not spawnedTorch then
		_increaseEvent(Events.Loot, 1000) -- increase chance to get torch
	else
		_increaseEvent(Events.Loot, 20)
	end

	if #items == 0 then
		_increaseEvent(Events.Enemy, 5)
	else
		_increaseEvent(Events.Enemy, 20)
	end

	if ev ~= Events.Nothing then
		_resetEvent(ev)
	end
end

function Game:_showRoomEvent(room, continue)
	local event_fn = {
		[Events.Loot] = function(loot) self.ui:showLootEvent(loot) end,
		[Events.Enemy] = function(enemy) self.ui:showEnemyEvent(enemy, self.player:getWeapons(), continue) end,
	}

	local ev = room:getEvent()
	self.ui:showNoEvents()

	if ev ~= nil and event_fn[ev[1]] ~= nil then
		event_fn[ev[1]](ev[2])
	end
end

function Game:_setNewRoomEvent(room)
	local ev = self:_randomEvent()

	local item = nil
	if ev == Events.Loot then
		item = _randomItem(loot_values) or Weapon.Stone
		if item == Loot.Torch then
			table.remove(loot_values, 1)
			spawnedTorch = true
		end
	end
	if ev == Events.Enemy then
		item = _randomItem(enemy_values) or Enemy.Bat
		room:setEnemy(Enemy(item))
	end
	room:setEvent(ev, item)
	self:_showRoomEvent(room)

	if ev == Events.Exit then
		foundExit = true
	end
	self:_updateEventChances(ev)
end

function Game:new()
	Game.super.new(self)

	self.player = Player()
	self.dungeon = Dungeon(20, 20, self.player)
	self.ui = MainContainer(self.dungeon, self.player)
	self:addChild(self.player, self.dungeon, self.ui)

	self.ui.onItemPickup:register(function(loot)
		self.player:addItem(loot)
		self.dungeon:activeRoom():removeEvent()
	end)
	self.ui.onAttack:register(function(weapon)
		self.player:disableInput()
		Timer.script(function(wait)
			wait(1)

			local enemy = self.dungeon:activeRoom():getEnemy()
			if enemy ~= nil then
				local dmg = weapon_dmg[weapon]
				enemy:hurt(dmg)
				self.ui:appendEventText('You deal' .. dmg .. ' damage.')
				wait(1)

				if enemy:isDead() then
					self.ui:setEventText('You killed the ' .. enemy:getType() .. '.')
					self.dungeon:activeRoom():removeEvent()

					-- TODO: get loot?
				else
					local enemy_dmg = enemy:getAttack()
					self.player:hurt(enemy_dmg) -- TODO: reduce based on armor
					self.ui:setEventText('The ' .. enemy .. ' attacks you and deals ' .. enemy_dmg .. ' damage.')
				end

				wait(1)
				self:_showRoomEvent(self.dungeon:activeRoom(), true)

				self.player:enableInput()
			end
		end)
	end)
	self.dungeon.onNewRoom:register(function(room) self:_setNewRoomEvent(room) end)
	self.dungeon.onRoomEnter:register(function(room) self:_showRoomEvent(room) end)
	self.dungeon:move(Vector.ZERO)
end

function Game:draw()
	Game.super.draw(self)
end

return Game
