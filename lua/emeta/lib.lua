-- TODO: open url

local Config = require("emeta.config").Config
local Sign = require("emeta.ui").Sign
local Theme = require("emeta.ui").Theme
local IBuffer = require("emeta.ibuffer").IBuffer
local Segment = require("emeta/text").Segment
local utils = require("emeta.utils")
local ev = utils.extend_vec
local Pos = utils.Pos

---@class Emeta
---@field cursor_pos Pos
---@field ibuffer IBuffer
---@field header Segment[]
---@field segments Segment[]
---@field selected_tab string
---@field flag_gen boolean
---@field ns string
---@field buf number
---@field win number
---@field tabs Tab[]
---@field config Config
---@field start_row number # 0-based
---@field start_col number # 0-based
local Emeta = {
    config = Config:new(),
    selected_tab = "Anime",
    buf = -1,
    win = -1,
    tabs = {
        { name = "Anime", key = "a" },
        { name = "Manga", key = "m" },
        { name = "Novel", key = "n" },
        { name = "Help", key = "?" },
    },
    segments = { Segment },
    ibuffer = IBuffer,
    cursor_pos = Pos,
    flag_gen = true,

    start_row = 0,
    start_col = 0,
}

---@class Tab
---@field name string
---@field key string
local Tab = {
    name = "",
    key = "",
}

Emeta.new = function(self)
    self.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(self.buf, "emeta")

    self.win = vim.api.nvim_open_win(self.buf, true, self.config.win)

    self.ns = self.ns or vim.api.nvim_create_namespace("Emeta-Namespace")

    self:set_keymap()
    self:gen()
    self:flush()
    self:reset_cursor()
end

Emeta.gen = function(self)
    self:clear()

    ev(self.header, {
        Segment.new_linebreak(),
    })

    for _, tab in ipairs(self.tabs) do
        local name = tab.name
        local key = tab.key

        local text = " " .. name .. " "
        local key_text = "(" .. string.upper(key) .. ")" .. " "

        local tmp = {
            Segment.new(tab.name, text, function()
                if self.selected_tab == name then
                    return "IncSearch"
                else
                    return ""
                end
            end, nil),
            Segment.new("#key", key_text, function()
                if self.selected_tab == name then
                    return "IncSearch"
                else
                    return "GruvboxOrange"
                end
            end, nil),
            Segment.new_space(),
        }

        ev(self.header, tmp)
    end

    if self.selected_tab == "Help" then
        ev(self.segments, {
            -- row 1-2
            Segment.new_linebreak(),
            Segment.new_linebreak(),

            -- row 3
            Segment.new_space(),
            Segment.new_space(),
            Segment.new_space(),
            Segment.new_space(),
            Segment.new_space(),
            Segment.new_space(),
            Segment.new_space(),
            Segment.new("#text", "July 2024", nil, nil),
            Segment.new_linebreak(),

            -- row 4
            Segment.new_space(),
            Segment.new("#text", "Su ", nil, nil),
            Segment.new("#text", "Mo ", nil, nil),
            Segment.new("#text", "Tu ", nil, nil),
            Segment.new("#text", "We ", nil, nil),
            Segment.new("#text", "Th ", nil, nil),
            Segment.new("#text", "Fr ", nil, nil),
            Segment.new("#text", "Sa ", nil, nil),
            Segment.new_linebreak(),

            -- 5
            Segment.new_space(),
            Segment.new_space(),
            Segment.new_space(),
            Segment.new_space(),
            Segment.new_space(),
            Segment.new_space(),
            Segment.new_space(),
            Segment.new_space(),
            Segment.new_space(),
            Segment.new_space(),
            Segment.new("#text", " 1 ", nil, nil),
            Segment.new("#text", " 2 ", nil, nil),
            Segment.new("#text", " 3 ", nil, nil),
            Segment.new("#text", " 4 ", function()
                return "GruvboxRed"
            end, nil),
            Segment.new_linebreak(),

            -- 6
            Segment.new_space(),
            Segment.new("#text", " 5 ", function()
                return "GruvboxYellow"
            end, nil),
            Segment.new("#text", " 6 ", nil, nil),
            Segment.new("#text", " 7 ", nil, nil),
            Segment.new("#text", " 8 ", nil, nil),
            Segment.new("#text", " 9 ", nil, nil),
            Segment.new("#text", "10 ", nil, nil),
            Segment.new("#text", "11 ", function()
                return "GruvboxRed"
            end, nil),
            Segment.new_linebreak(),

            -- 7
            Segment.new_space(),
            Segment.new("#text", "12 ", function()
                return "GruvboxYellow"
            end, nil),
            Segment.new("#text", "13 ", nil, nil),
            Segment.new("#text", "14 ", nil, nil),
            Segment.new("#text", "15 ", nil, nil),
            Segment.new("#text", "16 ", nil, nil),
            Segment.new("#text", "17 ", nil, nil),
            Segment.new("#text", "18 ", function()
                return "GruvboxRed"
            end, nil),
            Segment.new_linebreak(),

            -- 8
            Segment.new_space(),
            Segment.new("#text", "19 ", function()
                return "GruvboxYellow"
            end, nil),
            Segment.new("#text", "20 ", nil, nil),
            Segment.new("#text", "21 ", nil, nil),
            Segment.new("#text", "22 ", nil, nil),
            Segment.new("#text", "23 ", nil, nil),
            Segment.new("#text", "24 ", nil, nil),
            Segment.new("#text", "25 ", function()
                return "GruvboxRed"
            end, nil),
            Segment.new_linebreak(),

            -- 9
            Segment.new_space(),
            Segment.new("#text", "26 ", function()
                return "GruvboxYellow"
            end, nil),
            Segment.new("#text", "27 ", nil, nil),
            Segment.new("#text", "28 ", nil, nil),
            Segment.new("#text", "29 ", nil, nil),
            Segment.new("#text", "30 ", nil, nil),
            Segment.new("#text", "31 ", nil, nil),
            Segment.new_linebreak(),
        })
    end

    if self.selected_tab == "Anime" then
        ev(self.segments, {
            Segment.new_linebreak(),
            Segment.new_linebreak(),

            Segment.new_space(),
            Segment.new("#text", "Total items: 2", nil, nil),
            Segment.new_linebreak(),
            Segment.new_linebreak(),

            Segment.new_space(),
            Segment.new("!button", Sign.current, function()
                return Theme.green
            end, nil),
            Segment.new_space(),
            Segment.new("#text", "K-ON", nil, {
                onclick = function()
                    return {
                        Segment.new_space(),
                        Segment.new("#text", "├ GENRE", function()
                            return "CursorLineFold"
                        end, nil),
                        Segment.new_space(),
                        Segment.new("#sign", "", nil, nil),
                        Segment.new_space(),
                        Segment.new("#text", "K-ON, Music, Yuri", nil, nil),
                        Segment.new_linebreak(),

                        Segment.new_space(),
                        Segment.new("#text", "├ TRACK", function()
                            return "CursorLineFold"
                        end, nil),
                        Segment.new_space(),
                        Segment.new("#sign", "", nil, nil),
                        Segment.new_space(),
                        Segment.new("#text", "2024-07-01 ~ 2024-07-04", nil, nil),
                        Segment.new_linebreak(),

                        Segment.new_space(),
                        Segment.new("#text", "├ LINKS", function()
                            return "CursorLineFold"
                        end, nil),
                        Segment.new_space(),
                        Segment.new("#sign", "", nil, nil),
                        Segment.new_space(),
                        Segment.new("#link", "https://anilist.co", nil, nil),
                        Segment.new_linebreak(),
                    }
                end,
            }),
            Segment.new_linebreak(),

            Segment.new_space(),
            Segment.new("!button", Sign.current, function()
                return Theme.green
            end, nil),
            Segment.new_space(),
            Segment.new("#text", "Girls Band Cry", nil, {
                onclick = function()
                    return {
                        Segment.new_space(),
                        Segment.new("#text", "├ GENRE", function()
                            return "CursorLineFold"
                        end, nil),
                        Segment.new_space(),
                        Segment.new("#sign", "", nil, nil),
                        Segment.new_space(),
                        Segment.new("#text", "K-ON, Music, Yuri", nil, nil),
                        Segment.new_linebreak(),

                        Segment.new_space(),
                        Segment.new("#text", "├ TRACK", function()
                            return "CursorLineFold"
                        end, nil),
                        Segment.new_space(),
                        Segment.new("#sign", "", nil, nil),
                        Segment.new_space(),
                        Segment.new("#text", "2024-07-01 ~ 2024-07-04", nil, nil),
                        Segment.new_linebreak(),

                        Segment.new_space(),
                        Segment.new("#text", "├ LINKS", function()
                            return "CursorLineFold"
                        end, nil),
                        Segment.new_space(),
                        Segment.new("#sign", "", nil, nil),
                        Segment.new_space(),
                        Segment.new("#link", "https://anilist.co", nil, nil),
                        Segment.new_linebreak(),
                    }
                end,
            }),
            Segment.new_linebreak(),
        })
    else
    end

    self.flag_gen = true
end

---@param type "header"|"segments"
Emeta.render = function(self, type)
    for index, segment in ipairs(self[type]) do
        local name = segment.name
        local text = segment.text()
        local hl = segment.hl()

        local len = string.len(text)

        if text ~= "" then
            vim.api.nvim_put({ text }, "", true, false)

            vim.api.nvim_buf_set_extmark(self.buf, self.ns, self.start_row, self.start_col, {
                end_col = self.start_col + len,
                hl_group = hl,
            })
        elseif name == "#linebreak" then
            vim.api.nvim_put({ "", "" }, "", true, false)

            self.start_col = 0
            self.start_row = self.start_row + 1
            len = 1
        elseif name == "#space" then
            -- wrap on header
            if type == "header" and self.start_col >= self.config.w_limit then
                -- linebreak
                vim.api.nvim_put({ "", "" }, "", true, false)
                self.start_col = 0
                self.start_row = self.start_row + 1
                len = 1
            else
                vim.api.nvim_put({ " " }, "", true, false)
                len = 1
            end
        end

        -- row: 1-based
        -- col: 0-based
        if self.flag_gen == true then
            self.ibuffer = IBuffer
            local row = self.start_row + 1

            for i = 0, len, 1 do
                if self.ibuffer[type][row] == nil then
                    self.ibuffer[type][row] = {}
                end
                self.ibuffer[type][row][self.start_col + i] = index
            end
        end

        self.start_col = self.start_col + len
    end
end

Emeta.flush = function(self)
    vim.api.nvim_set_option_value("modifiable", true, { buf = self.buf })

    self.start_row = 0
    self.start_col = 0

    self:render("header")
    self:render("segments")

    self.flag_gen = false

    vim.api.nvim_set_option_value("modifiable", false, { buf = self.buf })
end

Emeta.set_keymap = function(self)
    vim.api.nvim_buf_set_keymap(self.buf, "n", "<CR>", "", {
        desc = "Toggle info",
        nowait = true,
        callback = function()
            self:sync_cursor()

            local pos = self.cursor_pos
            local id_header = self.ibuffer:get_header(pos)
            local id_segment = self.ibuffer:get_segment(pos)

            if id_header ~= nil then
                local id = id_header
                local tab = self.header[id]

                if tab ~= nil and not tab.name:match("^#") then
                    self:switch_tab(tab)
                end
            elseif id_segment ~= nil then
                local id = id_segment

                self:onclick(id)
            end
        end,
    })

    vim.api.nvim_buf_set_keymap(self.buf, "n", "q", "", {
        desc = "Exit",
        nowait = true,
        callback = function()
            if self.buf == nil then
                return
            end

            vim.api.nvim_set_option_value("modifiable", true, { buf = self.buf })

            vim.api.nvim_buf_clear_namespace(self.buf, self.ns, 0, -1)

            vim.api.nvim_buf_delete(0, {})
            self.buf = -1
            self.win = -1
        end,
    })

    for _, tab in pairs(self.tabs) do
        vim.api.nvim_buf_set_keymap(self.buf, "n", tab.key, "", {
            desc = "Switch to Tab",
            nowait = true,
            callback = function()
                self:switch_tab(tab)
            end,
        })
    end
end

Emeta.switch_tab = function(self, tab)
    vim.api.nvim_set_option_value("modifiable", true, { buf = self.buf })

    self.selected_tab = tab.name
    vim.api.nvim_buf_set_lines(0, 0, -1, 0, { "" })

    self:gen()
    self:flush()
    self:reset_cursor()
end

Emeta.onclick = function(self, id)
    -- debug
    local segment = self.segments[id]
    local name = segment.name

    if name == "#link" then
        local cmd, err = vim.ui.open(segment.text())

        if cmd then
            cmd:wait()
        else
            vim.print(err)
        end
    elseif name == "!button" then
        self:toggle_info(id)
    else
        vim.print(self.selected_tab .. " = " .. name .. "   " .. segment.text())
    end
end

Emeta.toggle_info = function(self, idx)
    local name = self.segments[idx].name

    self:sync_cursor()
    local last_pos = self.cursor_pos

    idx = self:skip_segment(idx, 2)

    vim.api.nvim_set_option_value("modifiable", true, { buf = self.buf })
    vim.api.nvim_buf_set_lines(0, 0, -1, 0, { "" })

    -- important
    self.flag_gen = true

    -- reset
    self.start_row = 0
    self.start_col = 0

    local opts = self.segments[idx].opts
    local meta = opts.onclick()

    if meta ~= nil then
        if opts.clicked == false then
            for index, value in ipairs(meta) do
                table.insert(self.segments, idx + 1 + index, value)
            end

            opts.clicked = true
        else
            local len = #meta

            for _ = 1, len, 1 do
                table.remove(self.segments, idx + 1)
            end

            opts.clicked = false
        end
    end

    self:flush()

    vim.api.nvim_win_set_cursor(self.win, last_pos)
end

---@return number
Emeta.skip_segment = function(self, idx, skip)
    return idx + skip
end

Emeta.reset_cursor = function(self)
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    self:sync_cursor()
end

Emeta.sync_cursor = function(self)
    -- cast tuple to Pos
    self.cursor_pos = vim.api.nvim_win_get_cursor(self.win)
end

Emeta.clear = function(self)
    self.segments = {}
    self.header = {}
end

-- vim.api.nvim_set_hl(0, "IAmTest", { fg = "#ffffff" })

return { Emeta = Emeta, Config = Config, IBuffer = IBuffer, Segment = Segment }
