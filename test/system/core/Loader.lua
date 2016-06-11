local loader = loadfile(ngx.var.root .. "/system/core/Loader.lua")():new()
local input = loader:load_core("Input"):new()