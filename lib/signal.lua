local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({ observer = {} }, Signal)
end

function Signal:register(f)
	self.observer[f] = f
	return f
end

function Signal:emit(...)
	for f in pairs(self.observer) do
		f(...)
	end
end

function Signal:remove(...)
	local f = { ... }
	for i = 1, select('#', ...) do
		self.observer[f[i]] = nil
	end
end

return Signal
