local MouseEvent = require 'lib.input.mouse-event'
local ResizeEvent = require 'lib.input.resize-event'

local Node2D = require 'lib.node.node2d'
local Screen = Node2D:extend()

function Screen:new(w, h, pixel)
	Screen.super.new(self)

	if pixel then
		love.graphics.setDefaultFilter("nearest", "nearest")
		love.graphics.setLineStyle("rough")
	end

	Unit.setScreenSize(w, h)
	self._gameSize = Vector(w, h)
	self._canvas = love.graphics.newCanvas(w, h)
	self:_updateScaleAndOffset()
	love.window.setMode(w, h, {})
end

function Screen:draw()
	love.graphics.setCanvas({ self._canvas, stencil = true })
	love.graphics.clear()

	Screen.super.draw(self)

	love.graphics.setCanvas()

	local sx, sy = self:_getScale()
	local pos = self:getGlobalPosition()

	love.graphics.draw(self._canvas, pos.x, pos.y, 0, sx, sy)
end

function Screen:_windowSize()
	return Vector(love.graphics.getDimensions())
end

function Screen:_toGame(x, y)
	local offset = self:getGlobalPosition()
	local pos = Vector(x, y) - offset
	pos = pos:divide(self._scale)

	return pos:value()
end

function Screen:_getScale()
	return self._scale.x, self._scale.y
end

function Screen:input(ev)
	if ev:is(MouseEvent) then
		ev:setPosition(self:_toGame(ev:getPosition()))
	elseif ev:is(ResizeEvent) then
		self:_updateScaleAndOffset()
	end

	Screen.super.input(self, ev)
end

function Screen:_updateScaleAndOffset()
	local realSize = self:_windowSize()
	local gameSize = self._gameSize

	local center = realSize / 2

	local realAspect = realSize.x / realSize.y
	local gameAspect = gameSize.x / gameSize.y

	if realAspect ~= gameAspect then
		if realSize.x < realSize.y then
			realSize.y = realSize.x / gameAspect
		else
			realSize.x = realSize.y * gameAspect
		end
	end

	self._scale = realSize:divide(gameSize)
	self:setGlobalPosition(center - realSize / 2)
end

return Screen
