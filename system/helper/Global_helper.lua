local Helper = {}

function Helper.atoi(str)
	str = tonumber(str)
	if nil == str then 
		return nil
	end
	return math.floor(str)
end

function Helper.split(str, delimiter)
	if nil == str or '' == str or nil == delimiter then
		return nil
	end
	local result = {}
	local params_num = 0
	local str = str .. delimiter
	for match in str:gmatch("(.-)" .. delimiter) do
		table.insert(result, match)
		params_num = params_num + 1
	end
	local last_length = #result[params_num]
	if "%" == string.sub(result[params_num], last_length, last_length) then
		result[params_num] = string.sub(result[params_num], 1, last_length - 1)
	end
	return result
end

return Helper