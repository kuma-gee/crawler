local Enemy = Class:extend()

local enemy_dmg = {
	[Enemy.Bat] = 1,
	[Enemy.Goblin] = 4,
	[Enemy.Skeleton] = 2
}

local enemy_health = {
	[Enemy.Bat] = 3,
	[Enemy.Goblin] = 8,
	[Enemy.Skeleton] = 5
}

function Enemy:new(type)
	self.onDied = Signal()

	self._type = type
	self._attack = enemy_dmg[type]
	self._health = enemy_health[type]
end

function Enemy:hurt(dmg)
	self._health = self._health - dmg
	if self._health <= 0 then
		self.onDied:emit()
	end
end

function Enemy:getAttack()
	return self._attack
end

function Enemy:isDead()
	return self._health <= 0
end

function Enemy:getType()
end

return Enemy
