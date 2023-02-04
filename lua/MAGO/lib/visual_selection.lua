local lib_strings = require("MAGO.lib.strings_utils")

local M = {}

M.get_visual_range = function()
    local start_row, start_col = vim.fn.line("v"), vim.fn.col("v")
    local end_row, end_col = vim.fn.line("."), vim.fn.col(".")

    if vim.fn.mode() == "V" then
        start_col = 1
        end_col = vim.fn.col("$")
    end

    return start_row, start_col, end_row, end_col
end

M.get_selection_lines = function()
    local start_row, start_col, end_row, end_col = M.get_visual_range()

    local lines =
        vim.api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})

    return lines
end

M.get_selection_text = function(opts)
    opts = opts or {}
    local lines = M.get_selection_lines()

    if opts.dedent then
        lines = lib_strings.dedent(lines)
    end

    return table.concat(lines, "\n")
end

return M
