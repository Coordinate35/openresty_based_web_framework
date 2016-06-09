local cjson = require("cjson")

local Json = {}

Json._VERSION = "0.0.1"

function Json.encode_empty_as_object(tbe)
	return cjson.encode(tbe)
end

function Json.encode_empty_as_array(tbe)
	cjson.encode_empty_table_as_object(false)
	return cjson.encode(tbe)
end

function Json.decode(str)
	return cjson.decode(str)
end

return Json