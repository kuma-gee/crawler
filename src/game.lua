local Player = require "src.player"
local Dungeon = require 'src.dungeon'
local MainContainer = require 'src.main-container'
local Map = require 'src.map'


local Node = require 'lib.node'
local Game = Node:extend()

local player = Player()
local dungeon = Dungeon(20, 20, player)
local ui = MainContainer():addChild(Map(dungeon))

local Events = { Enemy = 'enemy', NPC = 'npc', Loot = 'loot', Exit = 'exit', Nothing = 'nothing' }
local Loot = { Torch = 0, Sword = 1, Armor = 2 }
local foundExit = false

local event_values = {
	[Events.Enemy] = 0,
	[Events.NPC] = 0,
	[Events.Loot] = 0,
	[Events.Exit] = 0,
	[Events.Nothing] = 800,
}

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

	_increaseEvent(Events.Enemy, 20)
	-- _increaseEvent(Events.NPC, 10)
	_increaseEvent(Events.Loot, 20)
	_resetEvent(ev)
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
end

return Game
