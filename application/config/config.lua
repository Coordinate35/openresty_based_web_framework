local config = {}

config.ROOT_PATH = ngx.var.root

config.APP_PATH = config.ROOT_PATH .. "/application"

config.SYSTEM_PATH = config.ROOT_PATH .. "/system"


return config