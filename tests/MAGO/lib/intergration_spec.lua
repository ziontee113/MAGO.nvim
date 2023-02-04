local intergration = require("MAGO.lib.intergration")
local test_helpers = require("MAGO.lib.test_helpers")

describe("can call cmd", function()
    before_each(function()
        test_helpers.set_lines([[
Hello World
Welcome Venus]])
    end)

    it("works", function()
        vim.cmd("norm! VG")
        vim.cmd("norm! ")
    end)
end)
