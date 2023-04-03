--[[
Copyright (c) 2010-2013 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]
--

local assert = assert
local sqrt, cos, sin, atan2 = math.sqrt, math.cos, math.sin, math.atan2

local vector = {}
vector.__index = vector

local function new(x, y)
	return setmetatable({ x = x or 0, y = y or 0 }, vector)
end

local zero = new(0, 0)
local up = new(0, -1)
local down = new(0, 1)
local left = new(-1, 0)
local right = new(1, 0)
local top_left = new(-1, -1)
local top_right = new(1, -1)
local bot_left = new(-1, 1)
local bot_right = new(1, 1)

local function fromPolar(angle, radius)
	radius = radius or 1
	return new(cos(angle) * radius, sin(angle) * radius)
end

local function randomDirection(len_min, len_max)
	len_min = len_min or 1
	len_max = len_max or len_min

	assert(len_max > 0, "len_max must be greater than zero")
	assert(len_max >= len_min, "len_max must be greater than or equal to len_min")

	return fromPolar(math.random() * 2 * math.pi,
		math.random() * (len_max - len_min) + len_min)
end

local function isvector(v)
	return type(v) == 'table' and type(v.x) == 'number' and type(v.y) == 'number'
end

function vector:clone()
	return new(self.x, self.y)
end

function vector:unpack()
	return self.x, self.y
end

function vector:__tostring()
	if self == zero then
		return "ZERO"
	end
	if self == up then
		return "UP"
	end
	if self == down then
		return "DOWN"
	end
	if self == left then
		return "LEFT"
	end
	if self == right then
		return "RIGHT"
	end
	if self == top_left then
		return "TOP_LEFT"
	end
	if self == top_right then
		return "TOP_RIGHT"
	end
	if self == bot_left then
		return "BOT_LEFT"
	end
	if self == bot_right then
		return "BOT_RIGHT"
	end

	return "(" .. tonumber(self.x) .. "," .. tonumber(self.y) .. ")"
end

function vector.__unm(a)
	return new(-a.x, -a.y)
end

function vector.__add(a, b)
	assert(isvector(a) and isvector(b), "Add: wrong argument types (<vector> expected)")
	return new(a.x + b.x, a.y + b.y)
end

function vector.__sub(a, b)
	assert(isvector(a) and isvector(b), "Sub: wrong argument types (<vector> expected)")
	return new(a.x - b.x, a.y - b.y)
end

function vector.__mul(a, b)
	if type(a) == "number" then
		return new(a * b.x, a * b.y)
	elseif type(b) == "number" then
		return new(b * a.x, b * a.y)
	else
		assert(isvector(a) and isvector(b), "Mul: wrong argument types (<vector> or <number> expected)")
		return a.x * b.x + a.y * b.y
	end
end

function vector.__div(a, b)
	assert(isvector(a) and type(b) == "number", "wrong argument types (expected <vector> / <number>)")
	return new(a.x / b, a.y / b)
end

function vector.__eq(a, b)
	return a.x == b.x and a.y == b.y
end

function vector.__lt(a, b)
	return a.x < b.x or (a.x == b.x and a.y < b.y)
end

function vector.__le(a, b)
	return a.x <= b.x and a.y <= b.y
end

function vector:abs()
	return new(math.abs(self.x), math.abs(self.y))
end

function vector:multiply(b)
	assert(isvector(b), "multiply: wrong argument types (<vector> expected)")
	return new(self.x * b.x, self.y * b.y)
end

function vector:divide(b)
	assert(isvector(b), "divide: wrong argument types (<vector> expected)")
	return new(self.x / b.x, self.y / b.y)
end

function vector:toPolar()
	return new(atan2(self.x, self.y), self:len())
end

function vector:len2()
	return self.x * self.x + self.y * self.y
end

function vector:len()
	return sqrt(self.x * self.x + self.y * self.y)
end

function vector:area()
	return self.x * self.y
end

function vector.dist(a, b)
	assert(isvector(a) and isvector(b), "dist: wrong argument types (<vector> expected)")
	local dx = a.x - b.x
	local dy = a.y - b.y
	return sqrt(dx * dx + dy * dy)
end

function vector.dist2(a, b)
	assert(isvector(a) and isvector(b), "dist: wrong argument types (<vector> expected)")
	local dx = a.x - b.x
	local dy = a.y - b.y
	return (dx * dx + dy * dy)
end

local function _normalizeToOne(v)
	if v == 0 then
		return 0
	end

	return math.floor(v / math.abs(v))
end

function vector:normalizedInGrid()
	return Vector(_normalizeToOne(self.x), _normalizeToOne(self.y))
end

function vector:normalizeInplace()
	local l = self:len()
	if l > 0 then
		self.x, self.y = self.x / l, self.y / l
	end
	return self
end

function vector:normalized()
	return self:clone():normalizeInplace()
end

function vector:rotateInplace(phi)
	local c, s = cos(phi), sin(phi)
	self.x, self.y = c * self.x - s * self.y, s * self.x + c * self.y
	return self
end

function vector:rotated(phi)
	local c, s = cos(phi), sin(phi)
	return new(c * self.x - s * self.y, s * self.x + c * self.y)
end

function vector:perpendicular()
	return new(-self.y, self.x)
end

function vector:projectOn(v)
	assert(isvector(v), "invalid argument: cannot project vector on " .. type(v))
	-- (self * v) * v / v:len2()
	local s = (self.x * v.x + self.y * v.y) / (v.x * v.x + v.y * v.y)
	return new(s * v.x, s * v.y)
end

function vector:mirrorOn(v)
	assert(isvector(v), "invalid argument: cannot mirror vector on " .. type(v))
	-- 2 * self:projectOn(v) - self
	local s = 2 * (self.x * v.x + self.y * v.y) / (v.x * v.x + v.y * v.y)
	return new(s * v.x - self.x, s * v.y - self.y)
end

function vector:cross(v)
	assert(isvector(v), "cross: wrong argument types (<vector> expected)")
	return self.x * v.y - self.y * v.x
end

-- ref.: http://blog.signalsondisplay.com/?p=336
function vector:trimInplace(maxLen)
	local s = maxLen * maxLen / self:len2()
	s = (s > 1 and 1) or math.sqrt(s)
	self.x, self.y = self.x * s, self.y * s
	return self
end

function vector:angleTo(other)
	if other then
		return atan2(self.y, self.x) - atan2(other.y, other.x)
	end
	return atan2(self.y, self.x)
end

function vector:trimmed(maxLen)
	return self:clone():trimInplace(maxLen)
end

function vector:maximize(v)
	return Vector(
		math.max(self.x, v.x),
		math.max(self.y, v.y)
	)
end

function vector:value()
	return self.x, self.y
end

-- the module
return setmetatable({
	new             = new,
	fromPolar       = fromPolar,
	randomDirection = randomDirection,
	isvector        = isvector,
	ZERO            = zero,
	UP              = up,
	DOWN            = down,
	LEFT            = left,
	RIGHT           = right,
	TOP_LEFT        = top_left,
	TOP_RIGHT       = top_right,
	BOT_LEFT        = bot_left,
	BOT_RIGHT       = bot_right,
}, {
	__call = function(_, ...) return new(...) end
})
