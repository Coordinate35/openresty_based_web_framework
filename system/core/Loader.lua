local const = loadfile(ngx.var.root .. "/application/config/config.lua")()

local Loader = {}

Loader._core_path = {
    const.SYSTEM_PATH .. "/core",
    const.APP_PATH .. "/core"
}
Loader._helper_path = {
    const.SYSTEM_PATH .. "/helper",
    const.APP_PATH .. "/helper"
}
Loader._library_path = {
    const.SYSTEM_PATH .. "/library",
    const.APP_PATH .. "/library"
}
Loader._lang_path = {
    const.SYSTEM_PATH .. "/lang",
    const.APP_PATH .. "/lang"
}
Loader._database_path = {
    const.SYSTEM_PATH .. "/database"
}
Loader._config_path = {
    const.APP_PATH .. "/config"
}
Loader._model_path = {
    const.APP_PATH .. "/model"
}
Loader._service_path = {
    const.APP_PATH .. "/service"
}
Loader._stage_path = {
    const.APP_PATH .. "/stage"
}
Loader._controller_path = {
    const.APP_PATH .. "/controller"
}
Loader._view_path = {
    const.APP_PATH .. "/view"
}

Loader._core = {}
Loader._helper = {}
Loader._library = {}
Loader._lang = {}
Loader._database = {}
Loader._config = {}

function Loader:load_core(core_name)
    return self:_load(core_name, "core")
end

function Loader:load_helper(helper_name)
    return self:_load(helper_name, "helper")
end

function Loader:load_library(library_name)
    return self:_load(library_name, "library")
end

function Loader:load_lang(lang_name)
    return self:_load(lang_name, "lang")
end

function Loader:load_database(database_name)
    return self:_load(database_name, "database")
end

function Loader:load_config(config_name)
    return self:_load(config_name, "config")
end

function Loader:load_model(model_name)
    return self:_load(model_name, "model")
end

function Loader:load_service(service_name)
    return self:_load(service_name, "service")
end

function Loader:load_stage(stage_name)
    return self:_load(stage_name, "stage")
end

function Loader:load_controller(controller_name)
    return self:_load(controller_name, "controller")
end

function Loader:load_view(view_name)
    return self:_load(view_name, "view")
end

function Loader:_load(name, class)
    local need_buffer_item = {"core", "helper", "library", "database", "config"}
    for _, value in pairs(need_buffer_item) do
        if value == class then
            return self:_load_with_buffer(name, class)
        end
    end
    return self:_load_without_buffer(name, class)
end

function Loader:_load_without_buffer(name, class)
    local file_name = value .. "/" .. name .. ".lua"
    local module
    if false == self:_file_exists(file_name) then
        print("Load " .. file_name .. " failed")
    else
        module = self:_load_module(file_name)
    end
    return module
end

function Loader:_load_with_buffer(name, class)
    if self["_" .. class][name] then
        return self["_" .. class][name]
    end
    local module
    for key, value in pairs(self["_" .. class .. "_path"]) do
        local file_name = value .. "/" .. name .. ".lua"
        if false == self:_file_exists(file_name) then
            print("Load " .. file_name .. " failed")
        else
            module = self:_load_module(file_name)
            self["_" .. class] = self:_merge_module(self["_" .. class], module)
        end
    end
    return self["_" .. class]
end

function Loader:_load_module(path)
    local module = loadfile(path)()
    if not module then
        print(loadfile(path))
        return nil
    end
    return module
end

-- Merge a module into another module, if exists, then replace it
function Loader:_merge_module(dest, module)
    for key, value in pairs(module) do
        dest[key] = value
    end
    return dest
end

function Loader:_file_exists(file_name)
    local file, err = io.open(file_name)
    if not file then
        return false
    end
    return true
end

function Loader:new()
    return setmetatable({}, {__index = self})
end

return Loader