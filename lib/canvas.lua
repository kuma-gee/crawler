local Plan = require "lib.plan"
local Container = Plan.Container
local Rules = Plan.Rules

local ResizeEvent = require 'lib.input.resize-event'
local Node = require 'lib.node'

local Canvas = Node:extend()

function Canvas:new()
	self.ui = Plan.new(Unit.w(1), Unit.h(1))
end

function Canvas:update(dt)
	self.ui:update(dt)
end

function Canvas:draw()
	self.ui:draw()
end

function Canvas:addChild(elem)
	self.ui:addChild(elem)
end

-- function Canvas:input(ev)
-- 	if ev:is(ResizeEvent) then
-- 		self.ui:refresh()
-- 	end
-- end

return Canvas
