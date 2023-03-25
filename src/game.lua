local Player = require "src.player"
local Dungeon = require 'src.dungeon'
local MainContainer = require 'src.main-container'
local Map = require 'src.map'


local Node = require 'lib.node'
local Game = Node:extend()

local player = Player()
local dungeon = Dungeon(20, 20, player)
local ui = MainContainer():addChild(Map(dungeon))

Events = { Enemy = 'enemy', NPC = 'npc', Loot = 'loot', Exit = 'exit', Nothing = 'nothing' }
Loot = { Torch = 'torch', Sword = 'sword', Armor = 'armor', Knife = 'knife', Corpse = 'corpse' }

local foundExit = false
local declinedTorch = false

local event_values = {
	[Events.Enemy] = 0,
	[Events.Loot] = 0,
	[Events.Exit] = 0,
	[Events.Nothing] = 800,
}

local function has_value(tab, val)
	for _, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
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

local function _randomEvent()
	if dungeon:getDiscoveredPercentage() > 0.8 then
		return Events.Exit
	end

	local values, total = _totalEventValue()
	local rand = math.random(0, total)

	for _, v in pairs(values) do
		print(table.concat(v, ','))
		if rand <= v[2] then
			return v[1]
		end
	end

	return Events.Nothing
end

local function _increaseEvent(ev, value)
	event_values[ev] = event_values[ev] + value
end

local function _resetEvent(ev)
	event_values[ev] = 0
end

local function _updateEventChances(ev)
	if not foundExit then
		event_values[Events.Exit] = dungeon:getDiscoveredPercentage() * 100
	else
		event_values[Events.Exit] = 0
	end

	local items = player:getInventory()

	if #items == 0 then
		_increaseEvent(Events.Loot, 1000) -- increase chance to get torch
	elseif #items == 1 and has_value(items, Loot.Torch) then
		_increaseEvent(Events.Loot, 100) -- increaase chance to get armor or weapon
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

function Game:new()
	Game.super.new(self)
	self:addChild(player, dungeon, ui)

	dungeon.onNewRoom:register(function()
		local ev = _randomEvent()
		print(ev)

		if ev == Events.Exit then
			foundExit = true
		end

		_updateEventChances(ev)
	end)
	dungeon:move(Vector.ZERO)
end

return Game
