local M = {}

local api = require("MAGO.lib.api")

vim.keymap.set("n", "<leader>t", function()
    local path = api.equivalent()

    local cmd = ":e " .. path
    vim.cmd(cmd)
end, { desc = "MAGO edit equivalent file" })

return M
