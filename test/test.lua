love = {
	graphics = {
		rectangle = function(...)
		end,
		setColor = function(...)
		end,
		getFont = function()
		end
	},
	mouse = {
		getX = function() return 0 end,
		getY = function() return 0 end
	}
}

require 'conf'

return require 'test.lust'
