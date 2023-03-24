local Button = require 'lib.node.control.button'
local Label = require 'lib.node.control.label'

local Super = require 'lib.node.control.container'
local MainContainer = Super:extend()


local btn = Button()
	:setTheme({ background = { 0, 0, 1, 0.5 }, padding = 5 })
	:addChild(Label("Inventory"))

function MainContainer:new()
	MainContainer.super.new(self, Vector.RIGHT, Vector.BOT_LEFT)
	self:setTheme({ background = { 1, 0, 0, 1 }, padding = 5 })

	self:setPosition(Vector(0, love.graphics.getHeight()))
	self:addChild(btn)
end

return MainContainer()
