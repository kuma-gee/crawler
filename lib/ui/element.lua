local Element = Class:extend()

function Element:new()
	self:setTheme({})
end

function Element:setTheme(theme)
	self._theme = table.merge(self._theme, theme)
end

function Element:getTheme()
	return self._theme
end

function Element.drawInColor(col, fn)
	local c = col or { 0, 0, 0, 1 }
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(c[1], c[2], c[3], c[4])
	fn()
	love.graphics.setColor(r, g, b, a)
end

-- function Element:draw()
-- 	local theme = self:getTheme()

-- 	if theme.background then
-- 		self:drawInColor(theme.background, function()
-- 			love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
-- 		end)
-- 	end

-- end

return Element
