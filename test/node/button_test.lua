local lust = require 'test.test'
local MouseEvent = require 'lib.input.mouse-event'
local Control = require 'lib.node.control'
local Button = require 'lib.node.control.button'
local describe, it, before, expect = lust.describe, lust.it, lust.before, lust.expect

local mouseX = 0
local mouseY = 0

love.mouse.getX = function() return mouseX end
love.mouse.getY = function() return mouseY end

describe('Button', function()
	local btn
	local click

	before(function()
		btn = Button()
		click = lust.spy(function()
		end)
		btn.onClick:register(function() click() end)
	end)

	it('set hover state', function()
		btn:addChild(Control():setSize(Vector(10, 2)))
		expect(btn:isHover()).to.equal(false)

		mouseX = 5
		mouseY = 1
		btn:update()

		expect(btn:isHover()).to.equal(true)
	end)

	it('set pressed state', function()
		btn:addChild(Control():setSize(Vector(10, 2)))
		expect(btn:isPressed()).to.equal(false)

		mouseX = 5
		mouseY = 1
		btn:update()

		btn:input(MouseEvent(Vector.ZERO, 1, true))
		expect(btn:isPressed()).to.equal(true)

		expect(#click).to.equal(1)

		btn:input(MouseEvent(Vector.ZERO, 1, false))
		expect(btn:isPressed()).to.equal(false)
	end)

	it('not set pressed if not hovering', function()
		btn:addChild(Control():setSize(Vector(10, 2)))
		btn:setPosition(Vector(1, 1))
		btn:update()

		btn:input(MouseEvent(Vector.ZERO, 1, true))
		expect(btn:isPressed()).to.equal(false)
	end)
end)
