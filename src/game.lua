local Player = require "src.player"
local Dungeon = require 'src.dungeon'
local MainContainer = require 'src.main-container'
local Enemy = require 'src.enemy'
local Item = require 'src.item'

local Event = require 'src.event'
local Node = require 'lib.node'
local Game = Node:extend()

function Game:_showRoomEvent(room, continue)
	self.ui:showNoEvents()
	self.ui:showInventoryActions(false)

	local enemy = room:getEnemy()
	if enemy ~= nil then
		self.ui:showInventoryActions(true)
		if continue == nil then
			self.ui:showEnemyEvent(enemy, continue)
		end
	end

	local items = room:getItems()
	if #items > 0 then
		self.ui:showLootEvent(items)
	end
end

function Game:_setNewRoomEvent(room)
	local ev = Event.randomEvent(self.dungeon, self.player)
	if ev == Event.Loot then
		local item = Item.randomItem()
		room:addItem(item)
	elseif ev == Event.Enemy then
		local enemy = Enemy.randomEnemy()
		room:setEnemy(enemy)
	end

	self:_showRoomEvent(room)
end

function Game:new()
	Game.super.new(self)

	self.player = Player()
	self.dungeon = Dungeon(50, 50, self.player)
	self.ui = MainContainer(self.dungeon, self.player)
	self:addChild(self.player, self.dungeon, self.ui)

	self.ui.onItemPickup:register(function(item)
		self.player:addItem(item)
		self.dungeon:activeRoom():removeItem(item)
	end)
	self.ui.onAttack:register(function(item)
		self.player:disableInput()
		local thrown = self.player:useItem(item)
		if thrown ~= nil then
			self.dungeon:activeRoom():addItem(item)
		end

		local dmg = item:getDamage()
		local enemy = self.dungeon:activeRoom():getEnemy()
		enemy:hurt(dmg)

		Timer.script(function(wait)
			self.ui:showPlayerAttack(dmg)
			wait(1)
			self.ui:showNoEvents()

			if enemy:isDead() then
				self.ui:showEnemyKilled(enemy)
				-- TODO: get loot?
			else
				self.ui:showEnemyAttack(enemy)
				self.player:hurt(enemy:getAttack()) -- TODO: reduce based on armor
			end

			wait(1)

			self:_showRoomEvent(self.dungeon:activeRoom(), true)
			self.player:enableInput()
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
