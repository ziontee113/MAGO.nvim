local M = {}

M.equivalent = function(path)
    path = path or vim.api.nvim_buf_get_name(0)
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

M.get_api_and_test_paths = function()
    local path = M.equivalent()
    local equivalent = M.equivalent(path)

    if string.match(path, "_spec.lua") then
        return { equivalent, path }
    else
        return { path, equivalent }
    end
end

return M
