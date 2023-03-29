local MouseEvent = require 'lib.input.mouse-event'
local ResizeEvent = require 'lib.input.resize-event'

local Node2D = require 'lib.node.node2d'
local Screen = Node2D:extend()

function Screen:new(w, h, pixel)
	Screen.super.new(self)
	self._canvas = love.graphics.newCanvas(w, h)

	if pixel then
		love.graphics.setDefaultFilter("nearest", "nearest")
		love.graphics.setLineStyle("rough")
	end
end

function Screen:_w()
	return self._canvas:getWidth()
end

function Screen:_h()
	return self._canvas:getHeight()
end

function Screen:load()
	local w, h = self._canvas:getDimensions()
	Unit.setScreenSize(w, h)
	love.window.setMode(w, h, {})
	self:_updateScale()
end

function Screen:draw()
	love.graphics.setCanvas(self._canvas)
	love.graphics.clear()

	Screen.super.draw(self)

	love.graphics.setCanvas()

	local sx, sy = self:_getScale()
	local pos = self:getPosition()

	love.graphics.draw(self._canvas, pos.x, pos.y, 0, sx, sy)
end

function Screen:_toGame(x, y)
	local sx, sy = self:_getScale()
	return x * sx, y * sy
end

function Screen:_getScale()
	return self._scale.x, self._scale.y
end

function Screen:input(ev)
	if ev:is(MouseEvent) then
		ev:setPosition(self:_toGame(ev:getPosition()))
	elseif ev:is(ResizeEvent) then
		self:_updateScale()
	end

	Screen.super.input(self, ev)
end

function Screen:_updateScale()
	local realSize = Vector(love.graphics.getDimensions())
	local gameSize = Vector(self._canvas:getDimensions())

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
	self:setPosition(center - realSize / 2)
end

return Screen
