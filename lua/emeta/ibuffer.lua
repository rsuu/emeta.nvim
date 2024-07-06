local Pos = require("emeta/utils").Pos

---@class IBuffer
---@field header number[][]
---@field segments number[][]
local IBuffer = {
    header = {},
    segments = {},
}

IBuffer.new = function(self)
    self.__index = self

    return setmetatable({
        header = {},
        segments = {},
    }, self)
end

---@param pos Pos
---@return number?
IBuffer.get_header = function(self, pos)
    local row, col = unpack(pos)

    if self.header[row] == nil then
        return nil
    else
        return self.header[row][col]
    end
end

---@param pos Pos
---@return number?
IBuffer.get_segment = function(self, pos)
    local row, col = unpack(pos)

    if self.segments[row] == nil then
        return nil
    else
        return self.segments[row][col]
    end
end

return { IBuffer = IBuffer }
