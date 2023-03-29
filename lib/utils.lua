table.contains = function(tab, val)
	for index, value in pairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end
