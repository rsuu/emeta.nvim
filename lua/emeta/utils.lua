---@class Pos
---@field row number
---@field col number
local Pos = { row = 1, col = 0 }

return {
    Pos = Pos,

    extend_vec = function(dst, src)
        for _, value in ipairs(src) do
            table.insert(dst, value)
        end
    end,
}
