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

describe("foundations for MAGO's api's magic function", function()
    it("works", function()
        local api_path = "/home/ziontee113/.config/dev-nvim/MAGO/lua/MAGO/lib/api.lua"
        local test_path = "/home/ziontee113/.config/dev-nvim/MAGO/tests/MAGO/lib/api_spec.lua"

        local cmd = "e " .. api_path
        vim.cmd(cmd)
        cmd = "vs " .. test_path
        vim.cmd(cmd)

        vim.cmd("norm! l")
        local buffer_path = vim.api.nvim_buf_get_name(0)
        assert.equal(test_path, buffer_path)
    end)
end)

describe("MAGO's api's get_api_and_test_paths", function()
    it("works", function()
        local api_path = "/home/ziontee113/.config/dev-nvim/MAGO/lua/MAGO/lib/api.lua"
        local test_path = "/home/ziontee113/.config/dev-nvim/MAGO/tests/MAGO/lib/api_spec.lua"

        local cmd = "e " .. api_path
        vim.cmd(cmd)

        local want = { api_path, test_path }
        local got = api.get_api_and_test_paths()
        assert.same(want, got)
    end)
end)

describe("MAGO's api's open_file_and_test_in_dual_splits()", function()
    it("works if current tab has 1 window open", function()
        local api_path = "/home/ziontee113/.config/dev-nvim/MAGO/lua/MAGO/lib/api.lua"
        local test_path = "/home/ziontee113/.config/dev-nvim/MAGO/tests/MAGO/lib/api_spec.lua"

        local cmd = "e " .. api_path
        vim.cmd(cmd)

        api.open_file_and_test_in_dual_splits()

        vim.cmd("norm! h")
        local api_buf_name = vim.api.nvim_buf_get_name(0)
        vim.cmd("norm! l")
        local test_buf_name = vim.api.nvim_buf_get_name(0)

        assert.equal(api_path, api_buf_name)
        assert.equal(test_path, test_buf_name)

        -- test environment clean up
        vim.cmd("q!")
    end)
    it("works if current tab has 2 windows open", function()
        local api_path = "/home/ziontee113/.config/dev-nvim/MAGO/lua/MAGO/lib/api.lua"
        local test_path = "/home/ziontee113/.config/dev-nvim/MAGO/tests/MAGO/lib/api_spec.lua"

        local cmd = "e " .. api_path
        vim.cmd(cmd)
        cmd = "vsp " .. "/home/ziontee113/.config/dev-nvim/MAGO/stylua.toml"
        vim.cmd(cmd)
        vim.cmd("norm! h")

        assert.equal(2, #vim.api.nvim_tabpage_list_wins(0))

        api.open_file_and_test_in_dual_splits()

        vim.cmd("norm! h")
        local api_buf_name = vim.api.nvim_buf_get_name(0)
        vim.cmd("norm! l")
        local test_buf_name = vim.api.nvim_buf_get_name(0)

        assert.equal(api_path, api_buf_name)
        assert.equal(test_path, test_buf_name)

        -- test environment clean up
        vim.cmd("q!")
    end)
    it("works if current tab has 4 windows open", function()
        local api_path = "/home/ziontee113/.config/dev-nvim/MAGO/lua/MAGO/lib/api.lua"
        local test_path = "/home/ziontee113/.config/dev-nvim/MAGO/tests/MAGO/lib/api_spec.lua"

        local cmd = "e " .. api_path
        vim.cmd(cmd)
        cmd = "vsp " .. "/home/ziontee113/.config/dev-nvim/MAGO/stylua.toml"
        vim.cmd(cmd)
        cmd = "vsp " .. "/home/ziontee113/.config/dev-nvim/MAGO/lua/MAGO/init.lua"
        vim.cmd(cmd)
        cmd = "vsp " .. "/home/ziontee113/.config/dev-nvim/MAGO/.gitignore"
        vim.cmd(cmd)

        vim.cmd("norm! h")
        vim.cmd("norm! h")
        vim.cmd("norm! h")
        vim.cmd("norm! h")
        assert.equal(4, #vim.api.nvim_tabpage_list_wins(0))

        api.open_file_and_test_in_dual_splits()
        print(vim.inspect(api.get_api_and_test_paths()))

        vim.cmd("norm! h")
        local api_buf_name = vim.api.nvim_buf_get_name(0)
        vim.cmd("norm! l")
        local test_buf_name = vim.api.nvim_buf_get_name(0)

        assert.equal(api_path, api_buf_name)
        assert.equal(test_path, test_buf_name)

        -- test environment clean up
        vim.cmd("q!")
    end)
end)
