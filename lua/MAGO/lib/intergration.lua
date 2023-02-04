local module = require("MAGO.lib.luastring_converter")

vim.api.nvim_create_user_command("SayHello", function()
    print("hello world")
end, {})
