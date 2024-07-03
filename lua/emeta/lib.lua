local Config = require("emeta.config").Config
local IBuffer = require("emeta.ibuffer").IBuffer
local Segment = require("emeta/text").Segment
local utils = require("emeta.utils")

local Emeta = {
    config = Config:new(),
    selected_tab = "Anime",
    buf = nil,
    tabs = {
        -- TODO: { a, A }
        { name = "Anime", key = "a" },
        { name = "Manga", key = "m" },
        { name = "Novel", key = "n" },
        { name = "Help", key = "?" },
    },
    segments = { Segment },
    ibuffer = IBuffer,
    cursor_pos = { row = 1, col = 0 },
    flag_gen = true,

    -- 0-based
    start_row = 0,
    start_col = 0,
}

Emeta.new = function(self)
    if self.buf ~= nil then
        return
    end

    self.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(self.buf, "emeta")

    self.win = vim.api.nvim_open_win(self.buf, true, self.config.win)
    vim.api.nvim_win_set_option(self.win, "modifiable", false)

    self.ns = self.ns or vim.api.nvim_create_namespace("EmetaNamespace")

    self:gen()
    self:set_keymap()
    self:flush()
    self:reset_cursor()
end

Emeta.gen = function(self)
    -- clear table
    self.segments = {}
    self.header = {}

    local ev = utils.extend_vec

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
            Segment.new("#text", "2020/07 (July)", nil, nil),
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
            Segment.new("#text", "Total: 38 plugins", nil, nil),
            Segment.new_linebreak(),
            Segment.new_linebreak(),

            Segment.new_space(),
            Segment.new("#text", "Loaded (36)", nil, nil),
            Segment.new_linebreak(),

            Segment.new_space(),
            Segment.new_space(),
            Segment.new_space(),
            Segment.new("#text", "●", function()
                return "GruvboxOrange"
            end, nil),
            Segment.new_space(),
            Segment.new("#text", "cmp-buffer", nil, nil),
            Segment.new_space(),
            Segment.new("#text", "12.18ms", nil, nil),
            Segment.new_space(),
            Segment.new("#text", "", function()
                return "GruvboxOrange"
            end, nil),
            Segment.new_space(),
            Segment.new("#text", "Anime", function()
                return "GruvboxGreen"
            end, nil),
            Segment.new_linebreak(),
            Segment.new_linebreak(),

            Segment.new_space(),
            Segment.new("#text", "Not Loaded (36)", nil, nil),
            Segment.new_linebreak(),

            Segment.new_space(),
            Segment.new_space(),
            Segment.new_space(),
            Segment.new("#text", "○", function()
                return "GruvboxOrange"
            end, nil),
            Segment.new_space(),
            Segment.new("#text", "cmp-buffer", nil, nil),
            Segment.new_space(),
            Segment.new("#text", "12.18ms", nil, nil),
            Segment.new_space(),
            Segment.new("#text", "", function()
                return "GruvboxOrange"
            end, nil),
            Segment.new_space(),
            Segment.new("#text", "Anime", function()
                return "GruvboxGreen"
            end, nil),
            Segment.new_linebreak(),
            Segment.new_linebreak(),
        })
    else
    end

    self.flag_gen = true
end

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
    vim.bo[self.buf].modifiable = true

    -- reset
    self.start_row = 0
    self.start_col = 0

    self:render("header")
    self:render("segments")

    self.flag_gen = false

    -- vim.api.nvim_set_hl(0, "IAmTest", { fg = "#ffffff" })

    vim.bo[self.buf].modifiable = false
end

Emeta.get_cursor = function(self)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    self.cursor_pos = { row, col }
end

Emeta.set_keymap = function(self)
    vim.api.nvim_buf_set_keymap(self.buf, "n", "<CR>", "", {
        desc = "Toggle info",
        nowait = true,
        callback = function()
            self:get_cursor()

            local row, col = unpack(self.cursor_pos)
            local id_header = self.ibuffer:get_header(row, col)
            local id_segment = self.ibuffer:get_segment(row, col)

            if id_header ~= nil then
                local id = id_header
                local tab = self.header[id]

                if tab ~= nil and not tab.name:match("^#") then
                    self:switch_tab(tab)
                end
            elseif id_segment ~= nil then
                local id = id_segment
                local segment = self.segments[id]
                self:toggle_info(segment)

                print(
                    self.selected_tab
                        .. row
                        .. "x"
                        .. col
                        .. " "
                        .. id
                        .. " = "
                        .. segment.name
                        .. "   "
                        .. segment.text()
                )
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

            vim.bo[self.buf].modifiable = true

            vim.api.nvim_buf_clear_namespace(self.buf, self.ns, 0, -1)
            vim.bo[self.buf].modifiable = false

            vim.api.nvim_buf_delete(0, {})
            self.buf = nil
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

Emeta.reset_cursor = function(self)
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
end

Emeta.switch_tab = function(self, tab)
    vim.bo[self.buf].modifiable = true

    self.selected_tab = tab.name
    vim.api.nvim_buf_set_lines(0, 0, -1, 0, { "" })

    self:reset_cursor()
    self:gen()
    self:flush()

    vim.bo[self.buf].modifiable = false
end

Emeta.toggle_info = function(self, segment)
    -- TODO: gen
end

return { Emeta = Emeta, Config = Config, IBuffer = IBuffer, Segment = Segment }
