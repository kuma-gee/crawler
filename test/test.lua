Vector = require 'lib.vector'

local Dungeon = require 'src.dungeon'
local lust = require 'test.lust'
local describe, it, expect = lust.describe, lust.it, lust.expect

describe('my project', function()
	lust.before(function()
		-- This gets run before every test.
	end)

	describe('module1', function()       -- Can be nested
		it('feature1', function()
			expect(1).to.be.a('number')  -- Pass
			expect('astring').to.equal('astring') -- Pass
		end)

		it('feature2', function()
			expect(nil).to.exist() -- Fail
		end)
	end)
end)
