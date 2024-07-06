local Chunk = {
    name = "",
    segments = {},
    opts = {},
}

---@class Segment
---@field name string
---@field text function
---@field hl function
---@field info {}
---@field opts {}
local Segment = {
    name = "",
    text = function()
        return ""
    end,
    hl = function()
        return ""
    end,
    info = {
        is_clicked = false,
    },
    opts = {},
}

---@return self
Segment.new = function(name, text, hl, opts)
    local _opts = function()
        if opts == nil then
            opts = {
                onclick = function()
                    return nil
                end,
            }
        end

        opts.onclick = opts.onclick or function()
            return nil
        end
        opts.clicked = false

        return opts
    end

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
        info = {
            is_clicked = false,
        },
        opts = _opts(),
    }
end

---@return self
Segment.new_space = function()
    return {
        name = "#space",
        text = function()
            return ""
        end,
        hl = function()
            return ""
        end,
        opts = function()
            return {
                onclick = function() end,
            }
        end,
    }
end

---@return self
Segment.new_linebreak = function()
    return {
        name = "#linebreak",
        text = function()
            return ""
        end,
        hl = function()
            return ""
        end,
        opts = function()
            return {
                onclick = function() end,
            }
        end,
    }
end

---@return self
Segment.new_tab = function()
    return {
        name = "#tab",
        text = function()
            return ""
        end,
        hl = function()
            return ""
        end,
        opts = function()
            return {
                onclick = function() end,
            }
        end,
    }
end

return { Chunk = Chunk, Segment = Segment }
