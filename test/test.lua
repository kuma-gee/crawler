local lust = require 'test.lust'
local Node = require 'lib.node'
local TestObj = require 'test.test-obj'
local Test = Node:extend()

local child = TestObj({ 1, 0, 0, 1 })
local root = TestObj({ 0, 1, 0, 1 }):addChild(child)

function Test:load()
	lust.it('set position for root node', function()
		lust.expect(root:getPosition()).to.equal(Vector.ZERO)

		root:setPosition(Vector(0, 10))
		lust.expect(root:getPosition()).to.equal(Vector(0, 10))
		lust.expect(root:getGlobalPosition()).to.equal(Vector(0, 10))
	end)

	lust.it('set position for child node', function()
		child:setPosition(Vector(5, 5))
		lust.expect(child:getPosition()).to.equal(Vector(5, 5))
		lust.expect(child:getGlobalPosition()).to.equal(Vector(5, 15))
	end)

	lust.it('set global position for child node', function()
		child:setGlobalPosition(Vector(10, 10))
		lust.expect(child:getPosition()).to.equal(Vector(10, 0))
		lust.expect(child:getGlobalPosition()).to.equal(Vector(10, 10))
	end)

	lust.it('set rotation for root node', function()
		root:setRotation(math.tau / 2)

		lust.expect(root:getPosition()).to.equal(Vector(0, 10))
		lust.expect(child:getPosition()).to.equal(Vector(10, 0))
		lust.expect(child:getGlobalPosition():trimmed(4)).to.equal(Vector(-10, 10))
	end)

	lust.it('set global position with rotation for child node', function()
		child:setGlobalPosition(Vector(10, 10))

		lust.expect(child:getPosition()).to.equal(Vector(-10, 0))
		lust.expect(child:getGlobalPosition():trimmed(4)).to.equal(Vector(10, 10))
	end)
end

function Test:draw()
	root:draw()
end

function Test:update(dt)
end

return Test
