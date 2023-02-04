local intergration = require("MAGO.lib.intergration")

describe("can call cmd", function()
    it("works", function()
        vim.cmd("SayHello")
    end)
end)
