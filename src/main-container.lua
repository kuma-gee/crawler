local Button = require 'lib.node.control.button'
local Label = require 'lib.node.control.label'
local ResizeEvent = require 'lib.input.resize-event'
local Container = require 'lib.node.control.container'

local Map = require 'src.map'

local MainContainer = Container:extend()

local health = Label()
local inventory = Container(Vector.DOWN):setTheme({ 0, 0.5, 0, 0.5 })
local inventoryAction = Container(Vector.DOWN):setTheme({ 0, 0.5, 0, 0.5 })
local statusContainer = Container(Vector.DOWN)
	:setTheme({ background = { 0, 0.5, 0, 0.5 } })
	:addChild(health)
	:addChild(inventory)
	:addChild(inventoryAction)

local mainTextContainer = Container(Vector.RIGHT)
	:setTheme({ background = { 0.5, 0.5, 0, 0.5 } })

function MainContainer:new(dungeon, player)
	MainContainer.super.new(self, Vector.RIGHT, Vector.DOWN, Container.Align.Stretch)
	self:setTheme({ background = { 0.5, 0, 0, 0.5 } })

	self.onItemPickup = Signal()
	self.onAttack = Signal()

	player.onHealthChange:register(function(hp, max_hp)
		health:setText('HP: ' .. hp .. ' / ' .. max_hp)
	end)
	player.onInventoryChange:register(function(items)
		inventory:clearChildren()
		inventoryAction:clearChildren()

		for _, item in ipairs(items) do
			inventory:addChild(Label(item:getType()))

			local btn = Button():addChild(Label(item:getType()))
			btn.onClick:register(function() self.onAttack:emit(item) end)
			inventoryAction:addChild(btn)
		end
	end)

	self:addChild(
		statusContainer:setMinSize(Unit.w(0.2), 0),

		mainTextContainer:setGrow(true),

		Map(dungeon):setMinSize(Unit.w(0.1), Unit.w(0.1))
		:setTheme({ background = { 0, 0, 0.5, 0.5 } })
	)

	self:setMinSize(Vector(Unit.w(1), 0))
	self:setPosition(Vector(Unit.w(0.5), Unit.h(1)))
end

function MainContainer:showNoEvents()
	mainTextContainer:clearChildren()
end

function MainContainer:showInventoryActions(show)
	if show then
		inventory:hide()
		inventoryAction:show()
	else
		inventory:show()
		inventoryAction:hide()
	end
end

function MainContainer:showEnemyEvent(enemy)
	mainTextContainer:addChild(Label('You encounter a ' .. enemy:getType() .. '. '))
end

function MainContainer:showLootEvent(items)
	mainTextContainer:clearChildren()
	mainTextContainer:addChild(Label('You found a '))

	for i, item in ipairs(items) do
		local pickupBtn = Button():addChild(Label(item:getType()))
		pickupBtn.onClick:register(function() self:_pickupItem(item) end)
		mainTextContainer:addChild(pickupBtn)

		if i ~= #items then
			mainTextContainer:addChild(Label(", "))
		end
	end
end

function MainContainer:_pickupItem(item)
	mainTextContainer:clearChildren()
	mainTextContainer:addChild(Label('You picked up a ' .. item:getType() .. '.'))
	self.onItemPickup:emit(item)
end

function MainContainer:showPlayerAttack(dmg)
	mainTextContainer:addChild(Label('You deal ' .. dmg .. ' damage. '))
end

function MainContainer:showEnemyKilled(enemy)
	mainTextContainer:addChild(Label('You killed the ' .. enemy:getType() .. '.'))
end

function MainContainer:showEnemyAttack(enemy)
	local enemy_dmg = enemy:getAttack()
	mainTextContainer:addChild(Label('The ' .. enemy:getType() .. ' attacks you and deals ' .. enemy_dmg .. ' damage.'))
end

return MainContainer
