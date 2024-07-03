local Chunk = {
    name = "",
    segments = {},
    opts = {},
}

local Segment = {
    name = "",
    text = function()
        return ""
    end,
    hl = function()
        return ""
    end,
    opts = {},
    -- on_click = function () end,

    ---@class Segment
    ---@field name string
    ---@field text function
    ---@field hl function
    ---@field opts {}
}

Segment.new = function(name, text, hl, opts)
    return {
        name = name,
        text = function()
            return text or ""
        end,
        hl = function()
            if hl ~= nil then
                return hl()
            else
                return ""
            end
        end,
        opts = function()
            return opts or {}
        end,
    }
end

Segment.new_space = function()
    return {
        name = "#space",
        text = function()
            return ""
        end,
        hl = function()
            return ""
        end,
        opts = {},
    }
end

Segment.new_linebreak = function()
    return {
        name = "#linebreak",
        text = function()
            return ""
        end,
        hl = function()
            return ""
        end,
        opts = {},
    }
end

Segment.new_tab = function()
    return {
        name = "#tab",
        text = function()
            return ""
        end,
        hl = function()
            return ""
        end,
        opts = {},
    }
end

return { Chunk = Chunk, Segment = Segment }
