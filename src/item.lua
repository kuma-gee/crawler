local Item = Class:extend()

local Types = { Torch = 'torch', Armor = 'armor', Sword = 'sword', Knife = 'Knife', Stone = 'stone' }

local weapon_dmg = {
	[Types.Sword] = 6,
	[Types.Knife] = 3,
	[Types.Stone] = 1,
}

local loot_values = {
	{ Types.Torch, 100 },
	{ Types.Knife, 20 },
	{ Types.Armor, 40 },
	{ Types.Sword, 50 },
}

local throw_items = {
	Types.Armor, Types.Stone
}

function Item:new(type)
	self._type = type
	self._throwable = table.contains(throw_items, type)
end

function Item:getType()
	return self._type
end

function Item:getDamage()
	return weapon_dmg[self._type] or 0
end

function Item:isThrowable()
	return self._throwable
end

local function _randomType(items)
	local rand = math.random(0, 100)

	for _, v in pairs(items) do
		if rand <= v[2] then
			return v[1]
		end
	end

	return Types.Stone
end

function Item.randomItem()
	local type = _randomType(loot_values)

	if type == Types.Torch then
		table.remove(loot_values, 1)
	end

	return Item(type)
end

return Item
