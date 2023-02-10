local M = {}

--=============== Strings Utils ===============

--- Returns whether the given string is empty or consists only of whitespaces
-- @param str (string) the string to check
-- @return (boolean) whether the string is empty or consists only of whitespaces
function M.if_string_empty(str)
    return string.match(str, "%s*") == str
end

--- Returns the length of the smallest common indentation of the given lines
-- @param lines (table of strings) an array of strings representing the lines to dedent
-- @return (number) the length of the smallest common indentation
local function get_smallest_indent(lines)
    local smallest_indent = math.huge
    for _, line in ipairs(lines) do
        local og_len = #line
        local trimmed = string.gsub(line, "^ +", "")
        local trimmed_len = #trimmed
        local spaces_len = og_len - trimmed_len
        if not M.if_string_empty(line) and (spaces_len < smallest_indent) then
            smallest_indent = spaces_len
        end
    end
    return smallest_indent
end

--- Dedents the input by removing the smallest common indentation from each line
-- @param input (string or table of strings) the input to dedent
-- @return (string or table of strings) the dedented input
M.dedent = function(input)
    local lines
    if type(input) == "table" then
        lines = input
    elseif type(input) == "string" then
        lines = vim.split(input, "\n")
    end

    local smallest_indent = get_smallest_indent(lines)
    local pattern = "^" .. string.rep(" ", smallest_indent)
    local new_lines = {}
    for _, line in ipairs(lines) do
        local new_line = string.gsub(line, pattern, "")
        table.insert(new_lines, new_line)
    end

    if type(input) == "table" then
        return new_lines
    end
    if type(input) == "string" then
        return table.concat(new_lines, "\n")
    end
end

-- QUESTION: why is this function so long?

-- QUESTION: what does it even do?

-- QUESTION: why is there no other places using this function outside the tests?
-- ANSWER: because we use the concatenation method from ranges to replace contents instead.

-- QUESTION: why so many arguments? I'm confused.
-- ANSWER: yes, we should refactor `start_row, start_col, end_row, end_col` to use a table instead.
-- doing so will however break implementations that depends on this `replace_range` function.

M.replace_range = function(input, replacement, range)
    local start_row, start_col, end_row, end_col = unpack(range)

    local lines
    if type(input) == "table" then
        lines = input
    elseif type(input) == "string" then
        lines = vim.split(input, "\n")
    end

    local lines_to_delete = {}
    for i, _ in ipairs(lines) do
        -- checks for lines to delete
        if i > start_row and i < end_row then
            table.insert(lines_to_delete, i)
        end

        local start = lines[i]:sub(1, start_col - 1)
        local _end = lines[i]:sub(end_col + 1)

        if i == start_row and i == end_row then
            lines[i] = start .. replacement .. lines[i]:sub(end_col + 1)
        else
            if i == start_row then
                lines[i] = start .. replacement
            end
            if i == end_row then
                lines[i] = _end
                if M.if_string_empty(lines[i]) then
                    table.insert(lines_to_delete, i)
                end
            end
        end
    end

    for i = #lines_to_delete, 1, -1 do
        table.remove(lines, lines_to_delete[i])
    end

    if type(input) == "table" then
        return lines
    end
    return table.concat(lines, "\n")
end

return M
