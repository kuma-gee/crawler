table.contains = function(tab, val)
	for index, value in pairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end

table.merge = function(tab1, tab2)
	local result = {}
	for k, v in pairs(tab1) do result[k] = v end
	for k, v in pairs(tab2) do result[k] = v end
	return result
end



table.removeValue = function(tab, value)
	for i, v in ipairs(tab) do
		if v == value then
			table.remove(tab, i)
			return value
		end
	end

	return nil
end


math.tau = math.pi * 2

math.round = function(n, decimalCount)
	if decimalCount == 0 then
		return math.floor(n)
	else
		local precision = 10 * decimalCount
		return math.floor(n * precision) / precision
	end
end
