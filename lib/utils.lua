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
		end
	end
end
