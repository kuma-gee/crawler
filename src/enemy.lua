local Enemy = Class:extend()
local Sprite = require 'lib.node.sprite'

local Types = { Bat = 'bat', Goblin = 'goblin', Skeleton = 'skeleton' }

local enemy_dmg = {
	[Types.Bat] = 1,
	[Types.Goblin] = 4,
	[Types.Skeleton] = 2
}

local enemy_health = {
	[Types.Bat] = 3,
	[Types.Goblin] = 8,
	[Types.Skeleton] = 5
}

local enemy_values = {
	{ Types.Bat,      0 },
	{ Types.Goblin,   20 },
	{ Types.Skeleton, 50 },
}

local enemy_sprites = {
	[Types.Bat] = Sprite(love.graphics.newImage('assets/Enemy_Bat_0.png', {})),
	[Types.Goblin] = Sprite(love.graphics.newImage('assets/Enemy_Bat_0.png', {})),
	[Types.Skeleton] = Sprite(love.graphics.newImage('assets/Enemy_Bat_0.png', {})),
}

function Enemy:new(type)
	self.onDied = Signal()

	self._type = type
	self._attack = enemy_dmg[type]
	self._health = enemy_health[type]
	self._sprite = enemy_sprites[type]
end

function Enemy:load()
	self._sprite:setGlobalPosition(Vector(Unit.w(0.5), Unit.h(0.5)))
end

function Enemy:hurt(dmg)
	self._health = self._health - dmg
	if self._health <= 0 then
		self.onDied:emit()
	end
end

function Enemy:draw()
	self._sprite:draw()
end

function Enemy:getAttack()
	return self._attack
end

function Enemy:isDead()
	return self._health <= 0
end

function Enemy:getType()
	return self._type
end

function Enemy.randomEnemy()
	local type = Enemy._randomType()
	return Enemy(type)
end

function Enemy._randomType()
	local rand = math.random(0, 100)

	for _, v in pairs(enemy_values) do
		if rand <= v[2] then
			return v[1]
		end
	end

	return enemy_values[1][1]
end

return Enemy
