local api = require("MAGO.lib.api")

describe("vim.api.nvim_buf_get_name(0)", function()
    local compare_path = function(path)
        local cmd = "e " .. path
        vim.cmd(cmd)

        local buffer_path = vim.api.nvim_buf_get_name(0)
        assert.equal(path, buffer_path)

        return vim.split(buffer_path, "/")
    end

    it("get correct path from buffer, file inside `lua` folder", function()
        local path = "/home/ziontee113/.config/dev-nvim/MAGO/lua/MAGO/lib/api.lua"
        local buffer_path_split = compare_path(path)

        assert.equal("lua", buffer_path_split[7])
    end)
    it("get correct path from buffer, file inside `tests` folder", function()
        local path = "/home/ziontee113/.config/dev-nvim/MAGO/tests/MAGO/lib/api.lua"
        local buffer_path_split = compare_path(path)

        assert.equal("tests", buffer_path_split[7])
    end)
end)

describe("MAGO's api's equivalent()", function()
    local compare_path = function(path, equivalent)
        local cmd = "e " .. path
        vim.cmd(cmd)

        local buffer_equivalent = api.equivalent()

        assert.equal(buffer_equivalent, equivalent)
    end

    it("works if file in `lua` folder", function()
        local path = "/home/ziontee113/.config/dev-nvim/MAGO/lua/MAGO/lib/api.lua"
        local equivalent = "/home/ziontee113/.config/dev-nvim/MAGO/tests/MAGO/lib/api_spec.lua"

        compare_path(path, equivalent)
    end)
    it("works if file in `tests` folder", function()
        local path = "/home/ziontee113/.config/dev-nvim/MAGO/tests/MAGO/lib/api_spec.lua"
        local equivalent = "/home/ziontee113/.config/dev-nvim/MAGO/lua/MAGO/lib/api.lua"

        compare_path(path, equivalent)
    end)

    it("works if file with `_spec` in it's name, in `lua` folder", function()
        local path = "/home/ziontee113/.config/dev-nvim/MAGO/lua/MAGO/lib/api_specification.lua"
        local equivalent =
            "/home/ziontee113/.config/dev-nvim/MAGO/tests/MAGO/lib/api_specification_spec.lua"

        compare_path(path, equivalent)
    end)
    it("works if file with `_spec` in it's name, in `tests` folder", function()
        local path =
            "/home/ziontee113/.config/dev-nvim/MAGO/tests/MAGO/lib/api_specification_spec.lua"
        local equivalent =
            "/home/ziontee113/.config/dev-nvim/MAGO/lua/MAGO/lib/api_specification.lua"

        compare_path(path, equivalent)
    end)
end)
