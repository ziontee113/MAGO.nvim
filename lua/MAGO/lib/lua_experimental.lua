local M = {}

local MagicSession = {
    original_input = nil,
    original_lines = {},

    x_offset = 0,
    y_offset = 0,

    left_delimiter = "{",
    right_delimiter = "}",
}
MagicSession.__index = MagicSession

function MagicSession:new(original_input)
    local session = setmetatable({}, MagicSession)

    session.original_input = original_input
    session.original_lines = original_input:split("\n")

    return session
end

function MagicSession:replace_range(range)
    local start_row, start_col, end_row, end_col = unpack(range)

    -- replace the range with the new one
    local test = self.original_input:sub(start_col, end_col)

    print(test)
end

M.MagicSession = MagicSession

return M
