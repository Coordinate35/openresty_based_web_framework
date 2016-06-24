local Input = {}

local Input._raw_input_stream
local Input._ip_address

local Input._is_xss_filter_open
local Input._post_array
local Input._get_array
local Input._headers
local Input._err

function Input:get_ip_address()
    return self._ip_address
end

-- Receive a table or a series of value
function Input:set_cookie(name, value, expire, domain, path, prefix, secure, http_only)
end

function Input:get_method(return_upper)
end

function Input:is_ajax_request()
end

function Input:get_request_headers(is_xss_filter_open)
end

function Input:get_request_header(header_name, is_xss_filter_open)
end

function Input:get_user_agent(is_xss_filter_open)
end

function Input:is_valid_ip()
end

function Input:cookie(var_name, is_xss_filter_open)
    return self:_fetch_from_array(self._cookie_array, var_name, is_xss_filter_open)
end

function Input:server(var_name, is_xss_filter_open)
    return self:_fetch_from_array(self._server_array, var_name, is_xss_filter_open)
end

function Input:get_post(var_name, is_xss_filter_open)
    if not self._get_array then
        self:post(var_name, is_xss_filter_open)
    else
        self:get(var_name, is_xss_filter_open)
    end
end

function Input:post_get(var_name, is_xss_filter_open)
    if not self._post_array then
        self:get(var_name, is_xss_filter_open)
    else
        self:post(var_name, is_xss_filter_open)
    end
end

-- Return get parameter named var_name.If var_name is nil,then return the whole array
function Input:get(var_name, is_xss_filter_open)
    return self:_fetch_from_array(self._get_array, var_name, is_xss_filter_open)
end

-- Return post parameter named var_name.If var_name is nil,then return the whole array
function Input:post(var_name, is_xss_filter_open)
    return self:_fetch_from_array(self._post_array, var_name, is_xss_filter_open)
end

function Input:_fetch_from_array(array, index, is_xss_filter_open)
end

function Input:_filter_xss(data)
end

function Input:_init_post_data()
    self._post_array, self._err = ngx.req.get_post_args()
    if self._err then
        print(self._err)
    end
end

function Input:_init_get_data()
    self._get_array = ngx.req.get_uri_args()
end

function Input:_init_headers()
    self._headers = ngx.req.get_headers()
end

function Input:_init_body_data()
    self._raw_input_stream = ngx.req.get_body_data
    if not self._raw_input_stream then
        ngx.req.get_body_file
    end
end

function Input:new(root)
    self._loader = root.loader
    self._is_xss_filter_open = false;

    ngx.req.read_body()
    self:_init_post_data()
    self:_init_get_data()
    self:_init_headers()
    self:_init_body_data()

    print("Input Class Initialized")
    return setmetatable({}, {__index = self})
end

return Input