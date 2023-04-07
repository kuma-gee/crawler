local Button = require 'lib.ui.button'
local Label = require 'lib.ui.label'
local Control = require 'lib.node.control'
local Container = require 'lib.node.control.container'

local Map = require 'src.map'

local MainContainer = Container:extend()

-- Label.setDefaultTheme({ background = { 1, 0, 0, 0 } })

-- local health = Label()
-- local inventory = Container(Vector.DOWN)
-- local inventoryAction = Container(Vector.DOWN)
-- local statusContainer = Container()
-- 	:addChild(health)
-- 	:addChild(inventory)
-- 	:addChild(inventoryAction)

-- local mainTextContainer = Container(Vector.RIGHT)

-- function MainContainer:new(dungeon, player)
-- 	MainContainer.super.new(self, Vector.RIGHT, Vector.DOWN)
-- 	self:setTheme({ background = { 0.5, 0, 0, 0.5 } })

-- 	self.onItemPickup = Signal()
-- 	self.onAttack = Signal()
-- 	self.onExit = Signal()

-- 	player.onHealthChange:register(function(hp, max_hp)
-- 		health:setText('HP: ' .. hp .. ' / ' .. max_hp)
-- 	end)
-- 	player.onInventoryChange:register(function(items)
-- 		inventory:clearChildren()
-- 		inventoryAction:clearChildren()

-- 		for _, item in ipairs(items) do
-- 			inventory:addChild(Label(item:getType()))

-- 			local btn = Button():addChild(Label(item:getType()))
-- 			btn.onClick:register(function() self.onAttack:emit(item) end)
-- 			inventoryAction:addChild(btn)
-- 		end
-- 	end)

-- 	local h = 0.2
-- 	self:addChild(
-- 		statusContainer,                            --:setFixedSize(Unit.w(0.19), Unit.h(h - 0.01)):setRelPosition(0.01, 0.01),
-- 		mainTextContainer:setGrow(true),            --:setFixedSize(Unit.w(0.7), Unit.h(h - 0.01)):setRelPosition(0.2, 0.01),
-- 		Map(dungeon):setMinSize(Unit.w(0.1), Unit.w(0.1)) --:setFixedSize(Unit.w(0.1), Unit.h(h)):setRelPosition(0.9, 0)
-- 	)

-- 	self:setFixedSize(Vector(Unit.w(1), Unit.h(h)))
-- 	self:setRelPosition(0.5, 1)
-- end

-- function MainContainer:showNoEvents()
-- 	mainTextContainer:clearChildren()
-- end

-- function MainContainer:showInventoryActions(show)
-- 	if show then
-- 		inventory:hide()
-- 		inventoryAction:show()
-- 	else
-- 		inventory:show()
-- 		inventoryAction:hide()
-- 	end
-- end

-- function MainContainer:showEnemyEvent(enemy)
-- 	self:showNoEvents()
-- 	mainTextContainer:addChild(Label('You encounter a ' .. enemy:getType() .. '. '))
-- end

-- function MainContainer:showLootEvent(items)
-- 	self:showNoEvents()
-- 	mainTextContainer:addChild(Label('You found a '))

-- 	for i, item in ipairs(items) do
-- 		local pickupBtn = Button():addChild(Label(item:getType()))
-- 		pickupBtn.onClick:register(function() self:_pickupItem(item) end)
-- 		mainTextContainer:addChild(pickupBtn)

-- 		if i ~= #items then
-- 			mainTextContainer:addChild(Label(", "))
-- 		end
-- 	end
-- end

-- function MainContainer:_pickupItem(item)
-- 	self:showNoEvents()
-- 	mainTextContainer:addChild(Label('You picked up a ' .. item:getType() .. '.'))
-- 	self.onItemPickup:emit(item)
-- end

-- function MainContainer:showPlayerAttack(dmg)
-- 	self:showNoEvents()
-- 	mainTextContainer:addChild(Label('You deal ' .. dmg .. ' damage. '))
-- end

-- function MainContainer:showEnemyKilled(enemy)
-- 	self:showNoEvents()
-- 	mainTextContainer:addChild(Label('You killed the ' .. enemy:getType() .. '.'))
-- end

-- function MainContainer:showEnemyAttack(enemy)
-- 	self:showNoEvents()
-- 	local enemy_dmg = enemy:getAttack()
-- 	mainTextContainer:addChild(Label('The ' .. enemy:getType() .. ' attacks you and deals ' .. enemy_dmg .. ' damage.'))
-- end

-- function MainContainer:showEnemyAttackMissed(enemy)
-- 	self:showNoEvents()
-- 	mainTextContainer:addChild(Label('The ' .. enemy:getType() .. ' attacks you and missed.'))
-- end

-- function MainContainer:showExit()
-- 	self:showNoEvents()
-- 	mainTextContainer:addChild(Label('You found the exit.'))

-- 	local pickupBtn = Button():addChild(Label('Leave'))
-- 	pickupBtn.onClick:register(function() self.onExit:emit() end)
-- 	mainTextContainer:addChild(pickupBtn)
-- end

-- return MainContainer
