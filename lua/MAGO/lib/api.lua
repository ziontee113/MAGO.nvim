local M = {}

M.equivalent = function()
    local path = vim.api.nvim_buf_get_name(0)
    local split = vim.split(path, "/")

    local prime_folder_index = 7 -- TODO: make this an argument

    if split[prime_folder_index] == "lua" then
        split[prime_folder_index] = "tests"
        split[#split] = string.match(split[#split], "(.+).lua$") .. "_spec.lua"
    elseif split[prime_folder_index] == "tests" then
        split[prime_folder_index] = "lua"
        split[#split] = string.gsub(split[#split], "_spec.lua$", ".lua")
    end

    return table.concat(split, "/")
end

return M
