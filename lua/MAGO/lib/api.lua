local M = {}

M.equivalent = function()
    local path = vim.api.nvim_buf_get_name(0)
    local split = vim.split(path, "/")

    local index = 7
    if split[index] == "lua" then
        split[index] = "tests"

        local file_name = string.match(split[#split], "(%a+).lua$")
        file_name = file_name .. "_spec.lua"
        split[#split] = file_name
    elseif split[index] == "tests" then
        split[index] = "lua"
        split[#split] = string.gsub(split[#split], "_spec.lua", ".lua")
    end

    return table.concat(split, "/")
end

return M
