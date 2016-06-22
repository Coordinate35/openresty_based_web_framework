local Input = {}

local Input.raw_input_stream

function Input:get_post(var_name, is_xss_filter_open)
end

function Input:post_get(var_name, is_xss_filter_open)
end

function Input:get(var_name, is_xss_filter_open)
end

function Input:post(var_name, is_xss_filter_open)
end

function Input:new()
    ngx.say("haha");
    return setmetatable({}, {__index = self})
end

return Input