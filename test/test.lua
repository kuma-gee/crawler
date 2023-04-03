local dimension

love = {
	graphics = {
		rectangle = function(...)
		end,
		setColor = function(...)
		end,
		getFont = function()
		end,
		newCanvas = function()
			return {}
		end,
		getDimensions = function()
			return dimension:value()
		end
	},
	mouse = {
		getX = function() return 0 end,
		getY = function() return 0 end
	},
	window = {
		setMode = function()
		end
	}
}

require 'conf'
local lust = require 'test.lust'

lust.setDimension = function(x, y)
	dimension = Vector(x, y)
end

lust.setDimension(1920, 1080)

return lust
