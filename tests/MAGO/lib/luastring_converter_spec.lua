local module = require("MAGO.lib.luastring_converter")

---@diagnostic disable: redefined-local
describe("convert_range()", function()
    local input = [[
poem:
Every day is a beautiful day.
Some other day is not something beautiful.]]

    it("converts `start_row, start_col, end_row, end_col` to `start_pos, end_pos`", function()
        -- case 1
        local want = { 7, 11 }
        local got = module.convert_range(input, { 2, 1, 2, 5 })

        assert.are.same(want, got)
        assert.equals("Every", input:sub(got[1], got[2]))

        -- case 2
        local want = { 42, 46 }
        local got = module.convert_range(input, { 3, 6, 3, 10 })

        assert.are.same(want, got)
        assert.equals("other", input:sub(got[1], got[2]))

        -- case 3
        local want = { 7, 46 }
        local got = module.convert_range(input, { 2, 1, 3, 10 })

        assert.are.same(want, got)
        assert.equals("Every day is a beautiful day.\nSome other", input:sub(got[1], got[2]))
    end)
end)

describe("FormatSession:add_range()", function()
    local original_content = [[
poem:
Every day is a beautiful day.
Some other day is not something beautiful.]]

    local session = module.FormatSession:new(original_content)

    it("works", function()
        session:add_range({ 2, 1, 2, 5 })

        local wanted_range = { 7, 11 }
        local converted_range = session.ranges[1]
        assert.same(wanted_range, converted_range)
        assert.equals("Every", original_content:sub(converted_range[1], converted_range[2]))
    end)
end)
