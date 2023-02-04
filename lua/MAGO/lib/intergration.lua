local module = require("MAGO.lib.luastring_converter")
local lib_selection = require("MAGO.lib.visual_selection")

local M = {
    pending_content = "",
}

M.handle_mode_changed = function(mode)
    if mode == "V" or mode == "v" then
        M.pending_content = lib_selection.get_selection_text({ dedent = true })
    elseif mode == "n" then
        print(M.pending_content)
    end
end

local augroup = vim.api.nvim_create_augroup("Snippet Sniper", { clear = true })

vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    pattern = "*",
    group = augroup,
    callback = function()
        M.handle_mode_changed(vim.fn.mode())
    end,
})

return M
