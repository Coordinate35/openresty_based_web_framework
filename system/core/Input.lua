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
function Input:set_cookie(...)
    local parameter = {...}
    local cookie_param = {}
    local cookie_item = {"name", "value", "expire", "domain", "path", "prefix", "secure", "http_only"}
    local number = #parameter
    if 1 == number and "table" == type(parameter[1]) then
        for key, value in pairs(cookie_item) do
            cookie_param[cookie_item[key]] = parameter[0][key]
        end
    else
        for key, value in pairs(cookie_item) do
            cookie_param[cookie_item[key]] = parameter[key]
        end
    end

    local cookie = cookie_param[name] .. "=" .. cookie_param[value]
    for key = 3, ＃cookie_item do
        if nil != cookie_param[cookie_item[key]] then
            cookie = cookie .. ";" .. cookie_item[key] .. "=" .. cookie_param[cookie_item[key]] 
        end
    end
    table.insert(ngx.header["Set-Cookie"], cookie);
end

function Input:get_method(return_upper)
    local method_name = ngx.req.get_method()
    if not return_upper or false == return_upper then
        return string.upper(method_name)
    end
    return string.lower(method_name)
end

function Input:is_ajax_request()
end

function Input:get_request_headers(is_xss_filter_open)
    local headers = {};
    for key, value in pairs(self.headers) do
        headers[key] = self:_fetch_from_array(self._headers, key, is_xss_filter_open)
    end
    return headers
end

function Input:get_request_header(header_name, is_xss_filter_open)
    return self:_fetch_from_array(self._headers, header_name, is_xss_filter_open)
end

function Input:get_user_agent(is_xss_filter_open)
    return self:_fetch_from_array(self._headers, "User-Agent", is_xss_filter_open)
end

function Input:is_valid_ip()
end

function Input:cookie(var_name, is_xss_filter_open)
    return self:_fetch_from_array(self._cookie_array, var_name, is_xss_filter_open)
end

-- function Input:server(var_name, is_xss_filter_open)
--     return self:_fetch_from_array(self._server_array, var_name, is_xss_filter_open)
-- end

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
    local output
    local value

    if "table" == type(index) then
        output = {}
        for key, _ in pairs(array) do
            output[key] = self:_fetch_from_array(array, key, is_xss_filter_open)
        end
        return output
    end

    if array[index] then
        value = array[index]
    else
        local iterator
        local match = {}
        local m
        local count = 0
        iterator, self._err = ngx.re.gmatch(index, "/(?:^[^\[]+)|\[[^]]*\]/")
        if self._err then
            print(self._err)
        end
        if iterator then
            while true do
                m, self._err = iterator()
                if self._err then
                    print(self._err)
                end
                if m then
                    count = count + 1
                    table.insert(match, m)
                else
                    break
                end
            end
        end
        if 1 < count then
            local k
            value = array
            for key, value in pairs(match) do
                k = self._global_helper.trim(value, "[]")
                if 0 == #k then
                    break
                end
                if not value[k] then
                    return nil
                else
                    value = value[k]
                end
            end
        else
            return nil
        end
    end

    if true == is_xss_filter_open then
        return self._security:xss_clean(value)
    end
    return value
end

function Input:_filter_xss(data)
    local is_image = false
    return self:_security:xss_clean(data, is_image)
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

function Input:_init_cookie()
    local cookie_key = {}
    for key, _ in pairs(ngx.var) do
        local match
        match = ngx.re.match(key, "cookie_")
        if match then
            table.insert(cookie_key, key)
        end
    end
    for _, value in pairs(cookie_key) do
        self._cookie_array[value] = ngx.var[value]
    end
end

function Input:new(root)
    self._loader = root.loader
    self._global_helper = root.global_helper
    self._is_xss_filter_open = false;
    self._security = self._loader:load_core("Security"):new()

    ngx.req.read_body()
    self:_init_post_data()
    self:_init_get_data()
    self:_init_headers()
    self:_init_body_data()
    self:_init_cookie()

    print("Input Class Initialized")
    return setmetatable({}, {__index = self})
end

return Input