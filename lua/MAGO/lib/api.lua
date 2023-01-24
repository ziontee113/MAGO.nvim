local M = {}

M.equivalent = function()
    local path = vim.api.nvim_buf_get_name(0)
    local path_split = vim.split(path, "/")

    local index = 7
    if path_split[index] == "lua" then
        path_split[index] = "tests"
    elseif path_split[index] == "tests" then
        path_split[index] = "lua"
    end

    return table.concat(path_split, "/")
end

return M
