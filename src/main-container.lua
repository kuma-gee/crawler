local Button = require 'lib.node.control.button'
local Label = require 'lib.node.control.label'
local ResizeEvent = require 'lib.input.resize-event'
local Container = require 'lib.node.control.container'

local Map = require 'src.map'

local MainContainer = Container:extend()


local textTheme = { color = { 1, 1, 1, 1 } }
local health = Label():setTheme(textTheme)
local statusContainer = Container(Vector.DOWN)
	:setTheme({ background = { 0, 0.5, 0, 0.5 } })
	:addChild(health)

local eventText = Label("Event here"):setTheme(textTheme)
local choiceContainer = Container(Vector.RIGHT)
	:setTheme({ background = { 0, 0.5, 0, 0.5 } })
local mainTextContainer = Container(Vector.DOWN)
	:setTheme({ background = { 0.5, 0.5, 0, 0.5 } })
	:addChild(eventText)
	:addChild(choiceContainer)

function MainContainer:new(dungeon, player)
	MainContainer.super.new(self, Vector.RIGHT, Vector.BOT_LEFT)
	self:setTheme({ background = { 0.5, 0, 0, 0.7 } })

	player.onHealthChange:register(function(hp, max_hp)
		health:setText('HP: ' .. hp .. ' / ' .. max_hp)
	end)

	self:addChild(
		statusContainer:setMinSize(Unit.w(0.2), Unit.w(0.1)),
		mainTextContainer:setMinSize(Unit.w(0.7), Unit.w(0.1)),
		Map(dungeon):setMinSize(Unit.w(0.1), Unit.w(0.1))
	)
end

function MainContainer:input(ev)
	if ev:is(ResizeEvent) then
		local x, y = ev:getSize()
		self:setMinSize(Vector(x, 0))
		self:setPosition(Vector(0, y))
	end

	MainContainer.super.input(self, ev)
end

function MainContainer:onEvent(ev)
	eventText:setText(ev)
end

return MainContainer
