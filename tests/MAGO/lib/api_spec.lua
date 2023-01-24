-- local api = require("MAGO.lib.api")

describe("MAGO api module", function()
    local compare_path = function(path)
        local cmd = "e " .. path
        vim.cmd(cmd)

        local buffer_path = vim.api.nvim_buf_get_name(0)
        assert.equal(path, buffer_path)

        return vim.split(buffer_path, "/")
    end

    it("get correct path from buffer, inside `lua` folder", function()
        local path = "/home/ziontee113/.config/dev-nvim/MAGO/lua/MAGO/lib/api.lua"
        local buffer_path_split = compare_path(path)

        assert.equal("lua", buffer_path_split[7])
    end)
    it("get correct path from buffer, inside `tests` folder", function()
        local path = "/home/ziontee113/.config/dev-nvim/MAGO/tests/MAGO/lib/api.lua"
        local buffer_path_split = compare_path(path)

        assert.equal("tests", buffer_path_split[7])
    end)
end)
