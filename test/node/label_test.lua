local lust = require 'test.test'
local Label = require 'lib.node.control.label'
local describe, it, before, expect = lust.describe, lust.it, lust.before, lust.expect

local font = {
	getHeight = function() return 10 end,
	getWidth = function(_, text) return 10 * text:len() end
}
love.graphics.getFont = function() return font end

describe('Label', function()
	it('set size based on text for font', function()
		local label = Label('Hello')
		label:update()

		expect(label:getSize()).to.equal(Vector(5 * 10, 10))
	end)
end)
