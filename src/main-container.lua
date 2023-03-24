local Button = require 'lib.node.control.button'
local Label = require 'lib.node.control.label'
local ResizeEvent = require 'lib.input.resize-event'

local Super = require 'lib.node.control.container'
local MainContainer = Super:extend()


local btn = Button()
	:setTheme({ background = { 0, 0.5, 0, 0.5 }, padding = 5 })
	:addChild(Label("Inventory"))

function MainContainer:new()
	MainContainer.super.new(self, Vector.RIGHT, Vector.BOT_LEFT)
	self:setTheme({ background = { 0, 0, 0, 0.7 }, padding = 5 })
	self:addChild(btn)
end

function MainContainer:input(ev)
	if ev:is(ResizeEvent) then
		local size = ev:getSize()
		self:setMinSize(Vector(size.x, 0)) -- TODO use relative sizes
		self:setPosition(Vector(0, size.y))
	end

	MainContainer.super.input(self, ev)
end

return MainContainer()
