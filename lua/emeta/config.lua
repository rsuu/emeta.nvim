-- local emeta = require("emeta")

local w = vim.api.nvim_win_get_width(0)
local h = vim.api.nvim_win_get_height(0)
local new_w = math.floor(w * 0.8)
local new_h = math.floor(h * 0.9)
local row = (h - new_h) / 2
local col = (w - new_w) / 2

local Config = {
    username = "test",
    win = {
        relative = "editor",
        width = new_w,
        height = new_h,
        row = row,
        col = col,
        focusable = false,
        style = "minimal",
    },
    w_limit = new_w * 0.6,
}

Config.new = function(self)
    return self
end

return { Config = Config }
