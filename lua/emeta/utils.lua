local M = {
    extend_vec = function(dst, src)
        for _, value in ipairs(src) do
            table.insert(dst, value)
        end
    end,
}

return M
