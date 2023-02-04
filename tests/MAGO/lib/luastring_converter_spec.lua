---@diagnostic disable: redefined-local
local module = require("MAGO.lib.luastring_converter")

local original_content = [[
poem:
Every day is a beautiful day.
Some other day is not something beautiful.]]

describe("convert_range()", function()
    it("converts `start_row, start_col, end_row, end_col` to `start_pos, end_pos`", function()
        -- case 1
        local want = { 7, 11 }
        local got = module.convert_range(original_content, { 2, 1, 2, 5 })

        assert.are.same(want, got)
        assert.equals("Every", original_content:sub(got[1], got[2]))

        -- case 2
        local want = { 42, 46 }
        local got = module.convert_range(original_content, { 3, 6, 3, 10 })

        assert.are.same(want, got)
        assert.equals("other", original_content:sub(got[1], got[2]))

        -- case 3
        local want = { 7, 46 }
        local got = module.convert_range(original_content, { 2, 1, 3, 10 })

        assert.are.same(want, got)
        assert.equals(
            "Every day is a beautiful day.\nSome other",
            original_content:sub(got[1], got[2])
        )
    end)
end)

describe("FormatSession:add_range()", function()
    local session = module.FormatSession.new(original_content)

    it("works the first time", function()
        assert.same(0, #session.ranges)
        session:add_range({ 2, 1, 2, 5 })

        local wanted_range = { 7, 11 }
        local converted_range = session.ranges[1]
        assert.same(wanted_range, converted_range)
        assert.equals("Every", original_content:sub(converted_range[1], converted_range[2]))
    end)

    it("works the second time, same session", function()
        session:add_range({ 3, 6, 3, 10 })

        local wanted_range = { 42, 46 }
        local converted_range = session.ranges[2]
        assert.same(wanted_range, converted_range)
        assert.equals("other", original_content:sub(converted_range[1], converted_range[2]))
    end)
end)

describe("FormatSession:produce_placeholder()", function()
    local session = module.FormatSession.new(original_content)

    it("works", function()
        session:add_range({ 2, 1, 2, 5 }) -- `Every` first word of line 2
        session:add_range({ 3, 6, 3, 10 }) -- `other` - 2nd word of line 3

        assert.same(#session.ranges, 2)

        local got = session:produce_placeholder()
        local want = [[
poem:
{} day is a beautiful day.
Some {} day is not something beautiful.]]

        assert.same(want, got)
    end)
end)
