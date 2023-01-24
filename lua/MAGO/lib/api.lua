local M = {}

local find_prime_folder_idex = function(path_split)
    local possible_targets = { "lua", "tests" }
    for i, split in ipairs(path_split) do
        for _, target in ipairs(possible_targets) do
            if split == target then
                return i
            end
        end
    end
end

M.equivalent = function(path)
    path = path or vim.api.nvim_buf_get_name(0)
    local split = vim.split(path, "/")

    local prime_folder_index = find_prime_folder_idex(split)

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

M.open_file_and_test_in_dual_splits = function(opts)
    local api_path, test_path = unpack(M.get_api_and_test_paths())
    local current_tab_wins = vim.api.nvim_tabpage_list_wins(0)

    if #current_tab_wins > 2 then
        for _ = 3, #current_tab_wins do
            vim.api.nvim_win_close(0, true)
        end
    end

    current_tab_wins = vim.api.nvim_tabpage_list_wins(0)

    if #current_tab_wins == 2 then
        vim.cmd("norm! h")
        local cmd = "e " .. api_path
        vim.cmd(cmd)
        vim.cmd("norm! l")
        cmd = "e " .. test_path
        vim.cmd(cmd)
    end

    if #current_tab_wins == 1 then
        local cmd = "e " .. api_path
        vim.cmd(cmd)
        cmd = "vs " .. test_path
        vim.cmd(cmd)
    end

    if opts and opts.swap == true then
        vim.cmd("norm! x")
    end
end

return M
