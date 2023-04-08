local Sprite = require 'lib.node.control.sprite'
local Label = require 'lib.node.control.label'
local Control = require 'lib.node.control'
local Item = Control:extend()

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

local item_sprites = {
	[Types.Torch] = love.graphics.newImage('assets/Item_Torch_0.png', {}),
}

local throw_items = {
	Types.Armor, Types.Stone
}

function Item:new(type)
	Item.super.new(self)
	self._type = type
	self._throwable = table.contains(throw_items, type)

	local img = item_sprites[type]
	if img then
		self._sprite = Sprite(img)
	else
		self._sprite = Label(type)
	end
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

function Item:draw()
	self._sprite:draw()
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

function Item:__tostring()
	return 'Item: ' .. self._type
end

return Item
