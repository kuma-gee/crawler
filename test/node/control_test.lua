local lust = require 'test.test'
local Control = require 'lib.node.control'
local describe, it, before, expect = lust.describe, lust.it, lust.before, lust.expect

describe('Control', function()
	for _, args in ipairs({
		{ Vector.ZERO,      Vector(-2, -2) },
		{ Vector.RIGHT,     Vector(-4, -2) },
		{ Vector.LEFT,      Vector(0, -2) },

		{ Vector.UP,        Vector(-2, 0) },
		{ Vector.TOP_LEFT,  Vector(0, 0) },
		{ Vector.TOP_RIGHT, Vector(-4, 0) },

		{ Vector.DOWN,      Vector(-2, -4) },
		{ Vector.BOT_LEFT,  Vector(0, -4) },
		{ Vector.BOT_RIGHT, Vector(-4, -4) },


	}) do
		it('should position based on anchor ' .. tostring(args[1]), function()
			local node = Control(args[1]):setSize(Vector(4, 4))
			expect(node:getTopLeftCorner()).to.equal(args[2])
		end)
	end

	it('should not go below min size', function()
		local node = Control():setMinSize(Vector(5, 5))
		expect(node:getSize()).to.equal(Vector(5, 5))

		node:setSize(Vector(2, 2))
		expect(node:getSize()).to.equal(Vector(5, 5))

		node:setSize(Vector(-10, -10))
		expect(node:getSize()).to.equal(Vector(5, 5))

		node:setSize(Vector(10, 10))
		expect(node:getSize()).to.equal(Vector(10, 10))
	end)
end)
