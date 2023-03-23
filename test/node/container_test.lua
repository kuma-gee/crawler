local lust = require 'test.test'
local Control = require 'lib.node.control'
local Container = require 'lib.node.control.container'
local describe, it, before, expect = lust.describe, lust.it, lust.before, lust.expect

describe('Container', function()
	for _, args in ipairs({
		{ Vector.LEFT,  Vector(9, 4) },
		{ Vector.RIGHT, Vector(9, 4) },
		{ Vector.DOWN,  Vector(5, 8) },
		{ Vector.UP,    Vector(5, 8) },
	}) do
		it('align children in direction ' .. tostring(args[1]), function()
			local container = Container(args[1])
			container:addChild(
				Control():setSize(Vector(5, 2)),
				Control():setSize(Vector(2, 2)),
				Control():setSize(Vector(2, 4))
			)
			container:update()

			expect(container:getSize()).to.equal(args[2])
		end)
	end

	it('align with padding', function()
		local container = Container(Vector.DOWN):setPadding(1)
		container:addChild(
			Control():setSize(Vector(5, 2)),
			Control():setSize(Vector(2, 2))
		)
		container:update()

		expect(container:getSize()).to.equal(Vector(7, 6))
	end)

	it('set padding', function()
		local container = Container(Vector.DOWN):setPadding(1)
		expect(container:getSize()).to.equal(Vector(2, 2))

		local container = Container(Vector.DOWN):setPadding({ 1, 2 })
		expect(container:getSize()).to.equal(Vector(4, 2))

		local container = Container(Vector.DOWN):setPadding({ 1, 2, 3, 4 })
		expect(container:getSize()).to.equal(Vector(6, 4))
	end)

	it('align nested container children', function()
		local container = Container(Vector.RIGHT)

		local child = Container(Vector.BOTTOM)
		child:addChild(
			Control():setSize(Vector(5, 2)),
			Control():setSize(Vector(2, 4))
		)

		container:addChild(
			child,
			Control():setSize(Vector(3, 3))
		)

		container:update()

		expect(child:getSize()).to.equal(Vector(5, 6))
		expect(container:getSize()).to.equal(Vector(8, 6))
	end)

	it('align nested container with padding', function()
		local container = Container(Vector.RIGHT):setPadding({ 2, 4 })

		local child = Container(Vector.BOTTOM):setPadding(2)
		child:addChild(
			Control():setSize(Vector(5, 2)),
			Control():setSize(Vector(2, 4))
		)

		container:addChild(
			child,
			Control():setSize(Vector(3, 3))
		)

		container:update()

		expect(child:getSize()).to.equal(Vector(9, 10))
		expect(container:getSize()).to.equal(Vector(20, 14))
	end)
end)
