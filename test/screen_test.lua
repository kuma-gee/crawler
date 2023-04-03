local test = require 'test.test'
local MouseEvent = require 'lib.input.mouse-event'
local Screen = require 'lib.screen'
local describe, it, before, expect = test.describe, test.it, test.before, test.expect

describe('Screen', function()
	it('adjust mouse event without offset', function()
		test.setDimension(1920, 1080)
		local screen = Screen(192, 108)

		local event = MouseEvent(1920, 1080)
		screen:input(event)
		expect(event:getPosition()).to.equal(192, 108)

		event = MouseEvent(1920 / 2, 1080 / 2)
		screen:input(event)
		expect(event:getPosition()).to.equal(192 / 2, 108 / 2)
	end)

	it('adjust mouse event with offset', function()
		test.setDimension(1000, 1000)
		local screen = Screen(200, 1000)

		local event = MouseEvent(400, 0)
		screen:input(event)
		expect(event:getPosition()).to.equal(0, 0)

		local event = MouseEvent(600, 1000)
		screen:input(event)
		expect(event:getPosition()).to.equal(200, 1000)

		local event = MouseEvent(1000, 1000)
		screen:input(event)
		expect(event:getPosition()).to.equal(600, 1000)
	end)
end)
