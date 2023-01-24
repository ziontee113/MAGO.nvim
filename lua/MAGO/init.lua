local M = {}

local api = require("MAGO.lib.api")

vim.keymap.set("n", "<leader>t", function()
    api.open_file_and_test_in_dual_splits({ swap = true })
end, { desc = "MAGO edit equivalent file" })

return M
