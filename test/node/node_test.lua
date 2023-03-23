local lust = require 'test.test'
local Node = require 'lib.node'
local describe, it, before, expect = lust.describe, lust.it, lust.before, lust.expect

describe('Node', function()
	local node

	before(function()
		node = Node()
	end)

	it('add children', function()
		node:addChild(Node(), Node())
		expect(#node:getChildren()).to.equal(2)
	end)

	it('add child with parent', function()
		local child = Node()
		node:addChild(child)
		expect(child:getParent()).to.be(node)
	end)

	it('call child methods', function()
		local child = Node()
		local load = lust.spy(child, 'load')
		local update = lust.spy(child, 'update')
		local draw = lust.spy(child, 'draw')
		local input = lust.spy(child, 'input')

		node:addChild(child)
		node:load()
		node:update(0)
		node:draw()
		node:input({})

		expect({ #load, #update, #draw, #input }).to.equal({ 1, 1, 1, 1 })
	end)
end)
