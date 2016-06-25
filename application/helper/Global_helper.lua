require "bit"

local Global_helper = {}

function Global_helper.trim(str, mask)
    local mode = 3
    Global_helper.do_trim(str, mask, mode)
end

function Global_helper.ltrim(str, mask)
    local mode = 2
    Global_helper.do_trim(str, mask, mode)
end

function Global_helper.rtrim(str, mask)
    local mode = 1
    Global_helper.do_trim(str, mask, mode)
end

function Global_helper.do_trim(str, mask, mode)
    if 0 == #str then
        return ""
    end

    if not mask then
        mask = " \t\n\r\0\x0B"
    end
    local left_edge = 1
    local right_edge = #str

    if 1 == bit.band(mode, 1) then
        -- Do trim right
        while string.find(mask, str[left_edge], 1, true) do
            left_edge = left_edge + 1 
        end
    end

    if 2 == bit.band(mode, 2) then
        -- Do trim left
        while string.find(mask, str[right_edge], 1, true) do
            right_edge = right_edge - 1
        end
    end

    return string.sub(str, left_edge, right_edge)
end

return Global_helper