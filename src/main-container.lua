local Button = require 'lib.node.control.button'
local Label = require 'lib.node.control.label'
local ResizeEvent = require 'lib.input.resize-event'
local Container = require 'lib.node.control.container'

local Map = require 'src.map'

local MainContainer = Container:extend()


local btn = Button()
	:setTheme({ background = { 0, 0.5, 0, 0.5 } })
	:addChild(Label("Inventory"))

local eventText = Label("Event here"):setTheme({ color = { 1, 1, 1, 1 } })

local choiceContainer = Container(Vector.RIGHT)
	:setTheme({ background = { 0, 0.5, 0, 0.5 } })
	:addChild(Label("Test"))
local mainTextContainer = Container(Vector.DOWN)
	:setTheme({ background = { 0.5, 0.5, 0, 0.5 } })
	:addChild(eventText)
	:addChild(choiceContainer)

local mapTheme = { background = { 0.5, 0, 0.5, 0.5 } }

function MainContainer:new(dungeon)
	MainContainer.super.new(self, Vector.RIGHT, Vector.BOT_LEFT)
	self:setTheme({ background = { 0.5, 0, 0, 0.7 } })

	self:addChild(
		btn:setMinSize(Unit.w(0.2), 0),
		mainTextContainer:setMinSize(Unit.w(0.7), Unit.w(0.1)),
		Map(dungeon):setMinSize(Unit.w(0.1), Unit.w(0.1)):setTheme(mapTheme)
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
