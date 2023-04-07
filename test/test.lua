local lust = require 'test.lust'
local Node = require 'lib.node'
local Container = require 'lib.node.control.container'
local TestObj = require 'test.test-obj'
local Test = Node:extend()

local Plan = require 'lib.plan'
local Canvas = require 'lib.canvas'
local Label = require 'lib.ui.label'

local child = TestObj({ 1, 0, 0, 1 })
local root = child
-- :addChild(child)

local Container = Plan.Container:extend()

function Test:new()
	local canvas = Canvas()

	local container = Container:new(
		Plan.Rules.new()
		:addX(Plan.center())
		:addY(Plan.pixel(20))
		:addWidth(Plan.aspect(1))
		:addHeight(Plan.relative(0.33))
	)

	canvas:addChild(container)
	self:addChild(canvas)
end

function Test:load()
	print('-------------------------- Start Test --------------------------')
	-- root = Container(Vector.RIGHT)
	-- 	:addChild(TestObj({ 0, 1, 0, 1 }))
	-- 	:addChild(TestObj({ 1, 0, 0, 1 }))

	-- lust.it('set position for root node', function()
	-- lust.expect(root:getPosition()).to.equal(Vector.ZERO)

	-- root:setPosition(Vector(0, 20))
	-- lust.expect(root:getPosition()).to.equal(Vector(0, 20))
	-- lust.expect(root:getGlobalPosition()).to.equal(Vector(0, 10))
	-- end)

	-- lust.it('set position for child node', function()
	-- 	child:setPosition(Vector(5, 5))
	-- 	lust.expect(child:getPosition()).to.equal(Vector(5, 5))
	-- lust.expect(child:getGlobalPosition()).to.equal(Vector(5, 15))
	-- end)

	-- lust.it('set global position for child node', function()
	-- 	child:setGlobalPosition(Vector(10, 10))
	-- 	lust.expect(child:getPosition()).to.equal(Vector(10, 0))
	-- 	lust.expect(child:getGlobalPosition()).to.equal(Vector(10, 10))
	-- end)

	-- lust.it('set rotation for root node', function()
	-- root:setRotation(math.tau / 4)

	-- lust.expect(root:getPosition()).to.equal(Vector(0, 10))
	-- lust.expect(child:getPosition()).to.equal(Vector(10, 0))
	-- lust.expect(child:getGlobalPosition():trimmed(4)).to.equal(Vector(-10, 10))
	-- end)

	-- lust.it('set global position with rotation for child node', function()
	-- 	child:setGlobalPosition(Vector(10, 10))

	-- 	lust.expect(child:getPosition()).to.equal(Vector(-10, 0))
	-- 	lust.expect(child:getGlobalPosition():trimmed(4)).to.equal(Vector(10, 10))
	-- end)
end

function Test:draw()
	root:draw()
end

function Test:update(dt)
	root:update()
end

return Test
