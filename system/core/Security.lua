local Security = {}

function Security:new()
    return setmetatable({}, {__index = self})
end

return Security