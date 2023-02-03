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

return M
