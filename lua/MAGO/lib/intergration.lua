local module = require("MAGO.lib.format_session")
local lib_selection = require("MAGO.lib.visual_selection")

local reduce_row_number = function(offset, start_row, start_col, end_row, end_col)
    end_row = end_row - offset + 1
    start_row = start_row - offset + 1

    return { start_row, start_col, end_row, end_col }
end

--------------------------------------------

-- TODO: handle `dedent` correctly
-- TODO: have better `dedent` control / logic flow

--------------------------------------------

local session

local init_session = function()
    local content = lib_selection.get_selection_text({ dedent = true })
    local row_offset = lib_selection.get_visual_range()
    session = module.FormatSession.new(content, row_offset)
end

local end_session = function()
    local result = session:produce_placeholder()
    N(result)

    session = nil
end

--------------------------------------------

vim.keymap.set("n", "<CR>", function()
    end_session()
end, {})

vim.keymap.set("x", "<CR>", function()
    if session then
        local content = lib_selection.get_selection_text({ dedent = true })
        local range = reduce_row_number(session.offset, lib_selection.get_visual_range())
        session:add_range(range, content)
    else
        init_session()
    end

    vim.cmd("norm! ")
end, {})
-- {{{nvim-execute-on-save}}}
