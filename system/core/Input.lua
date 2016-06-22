local Input = {}

local Input.raw_input_stream
local Input.ip_address

function method(return_upper)
end

function is_ajax_request()
end

function Input:request_headers(is_xss_filter_open)
end

function Input:get_request_header(header_name, is_xss_filter_open)
end

function Input:user_agent(is_xss_filter_open)
end

function Input:is_valid_ip()
end

function Input:cookie(var_name, is_xss_filter_open)
end

function Input:server(var_name, is_xss_filter_open)
end

function Input:get_post(var_name, is_xss_filter_open)
end

function Input:post_get(var_name, is_xss_filter_open)
end

function Input:get(var_name, is_xss_filter_open)
end

function Input:post(var_name, is_xss_filter_open)
end

function Input:_filter_xss(data)
end

function Input:new()
    return setmetatable({}, {__index = self})
end

return Input