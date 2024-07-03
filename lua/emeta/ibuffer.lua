local IBuffer = {
    header = {},
    segments = {},

    ---@class IBuffer
    ---@field header table
    ---@field segments table
}

IBuffer.new = function(self)
    self.__index = self

    return setmetatable({
        header = {},
        segments = {},
    }, self)
end

---@param self IBuffer
---@param row integer
---@param col integer
---@return integer?
IBuffer.get_header = function(self, row, col)
    if self.header[row] == nil then
        return nil
    else
        return self.header[row][col]
    end
end

---@param self IBuffer
---@param row integer
---@param col integer
---@return integer?
IBuffer.get_segment = function(self, row, col)
    if self.segments[row] == nil then
        return nil
    else
        return self.segments[row][col]
    end
end

return { IBuffer = IBuffer }
