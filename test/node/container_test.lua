local lust = require 'test.test'
local Control = require 'lib.node.control'
local Container = require 'lib.node.control.container'
local describe, it, before, expect = lust.describe, lust.it, lust.before, lust.expect

describe('Container', function()
	for _, args in ipairs({
		{ { Vector.RIGHT, Vector.TOP_LEFT }, { Vector(5, 2), Vector(2, 2) },
			Vector(7, 2), { Vector(0, 0), Vector(5, 0) } },
		{ { Vector.RIGHT, Vector.TOP_RIGHT }, { Vector(5, 2), Vector(2, 2) },
			Vector(7, 2), { Vector(-7, 0), Vector(-2, 0) } },
		{ { Vector.RIGHT, Vector.BOT_LEFT }, { Vector(5, 2), Vector(2, 2) },
			Vector(7, 2), { Vector(0, -2), Vector(5, -2) } },
		{ { Vector.RIGHT, Vector.BOT_RIGHT }, { Vector(5, 2), Vector(2, 2) },
			Vector(7, 2), { Vector(-7, -2), Vector(-2, -2) } },

		{ { Vector.DOWN, Vector.TOP_LEFT }, { Vector(5, 2), Vector(2, 2) },
			Vector(5, 4), { Vector(0, 0), Vector(0, 2) } },
		{ { Vector.DOWN, Vector.TOP_RIGHT }, { Vector(5, 2), Vector(2, 2) },
			Vector(5, 4), { Vector(-5, 0), Vector(-5, 2) } },
		{ { Vector.DOWN, Vector.BOT_LEFT }, { Vector(5, 2), Vector(2, 2) },
			Vector(5, 4), { Vector(0, -4), Vector(0, -2) } },
		{ { Vector.DOWN,  Vector.BOT_RIGHT }, { Vector(5, 2), Vector(2, 2) },
			Vector(5, 4), { Vector(-5, -4), Vector(-5, -2) } },
	}) do
		local containerArgs = args[1]

		it('align children in ' .. tostring(containerArgs[1]) ..
			' direction with anchor ' .. tostring(containerArgs[2]), function()
				local controlArgs = args[2]

				local container = Container(containerArgs[1], containerArgs[2])
				local controls = {}

				for _, size in ipairs(controlArgs) do
					local c = Control():setSize(size)
					table.insert(controls, c)
					container:addChild(c)
				end

				container:update()

				local expectedSize = args[3]
				expect(container:getSize()).to.equal(expectedSize)

				local expectedPositions = args[4]

				for i, c in ipairs(controls) do
					expect(c:getTopLeftCorner()).to.equal(expectedPositions[i])
				end
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
