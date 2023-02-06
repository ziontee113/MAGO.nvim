local M = {}

M.get_new_line_positions = function(input)
    local new_line_positons = { 0 }

    local first = 0
    while true do
        first = input:find("\n", first + 1)
        table.insert(new_line_positons, first)
        if not first then
            break
        end
    end

    return new_line_positons
end

M.convert_range = function(input, range)
    local new_line_positons = M.get_new_line_positions(input)
    local start_row, start_col, end_row, end_col = unpack(range)

    local start_pos = new_line_positons[start_row] + start_col
    local end_pos = new_line_positons[end_row] + end_col

    return { start_pos, end_pos }
end

local FormatSession = {
    original_content = "",
    offset = nil,
    ranges = {},

    left_delimiter = "{",
    right_delimiter = "}",
}
FormatSession.__index = FormatSession

function FormatSession.new(original_content, offset)
    local session = vim.deepcopy(FormatSession)
    session.original_content = original_content
    session.offset = offset

    return session
end

function FormatSession:add_range(range)
    table.insert(self.ranges, M.convert_range(self.original_content, range))
end

function FormatSession:display_content()
    return self.original_content
end

function FormatSession:produce_placeholder()
    local final_result = ""
    local last_index = 1

    for i, range in ipairs(self.ranges) do
        local content_piece = self.original_content:sub(last_index, range[1] - 1)

        last_index = range[2] + 1

        if i == 1 then
            final_result = content_piece
        else
            final_result = final_result
                .. self.left_delimiter
                .. self.right_delimiter
                .. content_piece
        end
    end

    local final_piece = self.original_content:sub(last_index, #self.original_content)
    final_result = final_result .. self.left_delimiter .. self.right_delimiter .. final_piece

    return final_result
end

M.FormatSession = FormatSession

return M
