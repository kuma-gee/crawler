local Logger = {}
Logger.__index = Logger

local Level = { ERROR = 0, WARN = 1, INFO = 2, DEBUG = 3, TRACE = 4 }
local logging_level = Level.INFO

local function setLoggingLevel(lvl)
	logging_level = lvl
end

function Logger.new(name)
	return setmetatable({ _name = name }, Logger)
end

function Logger:info(msg)
	self:_logForLevel(Level.INFO, msg)
end

function Logger:debug(msg)
	self:_logForLevel(Level.DEBUG, msg)
end

function Logger:warn(msg)
	self:_logForLevel(Level.WARN, msg)
end

function Logger:error(msg)
	self:_logForLevel(Level.ERROR, msg)
end

function Logger:_logForLevel(lvl, msg)
	if logging_level >= lvl then
		local time = os.date('%Y/%m/%d %H:%M:%S')
		print('[' .. time .. ' - ' .. self._name .. ']:' .. tostring(msg))
	end
end

return setmetatable({ Level = Level, logging_level = logging_level, setLoggingLevel = setLoggingLevel }, Logger)
