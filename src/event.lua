local Events = { Enemy = 'enemy', NPC = 'npc', Loot = 'loot', Exit = 'exit', Nothing = 'nothing' }

local foundExit = false

local event_values = {
	[Events.Enemy] = 0,
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

local function _increaseEvent(ev, value)
	event_values[ev] = event_values[ev] + value
end

local function _resetEvent(ev)
	if ev ~= Events.Nothing then
		event_values[ev] = 0
	end
end

local function _updateEventChances(ev, dungeon, player)
	if not foundExit then
		event_values[Events.Exit] = dungeon:getDiscoveredPercentage() * 100
	else
		event_values[Events.Exit] = 0
	end

	local items = player:getInventory()

	if #items == 0 then
		_increaseEvent(Events.Loot, 1000) -- increase chance to get torch
		_increaseEvent(Events.Enemy, 5)
	else
		_increaseEvent(Events.Loot, 20)
		_increaseEvent(Events.Enemy, 200)
	end

	_resetEvent(ev)
end

local function _randomEvent(dungeon)
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

local function getRandomEventAndUpdate(dungeon, player)
	local ev = _randomEvent(dungeon)
	if ev == Events.Exit then
		foundExit = true
	end

	_updateEventChances(ev, dungeon, player)
	return ev
end

return setmetatable({ randomEvent = getRandomEventAndUpdate, Enemy = Events.Enemy, Loot = Events.Loot }, {})
