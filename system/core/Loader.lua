local loader = {}

function loader:_load_module(path)
    local module = loadfile(path)()
    if not module then
        print(loadfile(path))
    end
    return module
end

function loader:new()
    local const = loadfile(self.root_path .. "/application/config/config.lua")()
    self._core_path = {
        const.SYSTEM_PATH .. "/core",
        const.APP_PATH .. "/core"
    }
    self._helper_path = {
        const.SYSTEM_PATH .. "/helper",
        const.APP_PATH .. "/helper"
    }
    self._library_path = {
        const.SYSTEM_PATH .. "/library",
        const.APP_PATH .. "/library"
    }
    self._lang_path = {
        const.SYSTEM_PATH .. "/lang",
        const.APP_PATH .. "/lang"
    }
    self._database_path = {
        const.SYSTEM_PATH .. "/database"
    }
    self._config_path = {
        const.APP_PATH .. "/config"
    }
    self._model_path = {
        const.APP_PATH .. "/model"
    }
    self._service_path = {
        const.APP_PATH .. "/service"
    }
    self._stage_path = {
        const.APP_PATH .. "/stage"
    }
    self._controller_path = {
        const.APP_PATH .. "/controller"
    }
    self._view_path = {
        const.APP_PATH .. "/view"
    }

    self._core = {}
    self._helper = {}
    self._library = {}
    self._lang = {}
    self._database = {}
    self._config = {}

    return setmetatable({}, {__index = self})
end

return loader