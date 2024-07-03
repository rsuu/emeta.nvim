local Cmd = {
    vim_cmd = "Emeta",
}

Cmd.new = function(self)
    vim.api.nvim_create_user_command(self.vim_cmd, function()
        require("emeta/lib").Emeta:new()
    end, { bang = true, desc = "emeta" })
end

return { Cmd = Cmd }
