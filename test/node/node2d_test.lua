local lust = require 'test.test'
local Node2D = require 'lib.node.node2d'
local describe, it, before, expect = lust.describe, lust.it, lust.before, lust.expect

describe('Node2D', function()
	local node

	before(function()
		node = Node2D()
	end)

	it('get local and global position', function()
		local child = Node2D()
		node:addChild(child)

		child:setPosition(Vector(1, 1))
		node:setPosition(Vector(5, 5))

		expect(child:getPosition()).to.equal(Vector(1, 1))
		expect(child:getGlobalPosition()).to.equal(Vector(6, 6))

		expect(node:getPosition()).to.equal(Vector(5, 5))
		expect(node:getGlobalPosition()).to.equal(Vector(5, 5))
	end)
end)
