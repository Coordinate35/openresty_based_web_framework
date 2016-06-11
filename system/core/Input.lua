local Input = {}

function Input:new()
    ngx.say("haha");
    return setmetatable({}, {__index = self})
end

return Input