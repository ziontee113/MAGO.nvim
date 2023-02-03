local module = require("MAGO.lib.luastring_converter")

---@diagnostic disable: redefined-local
describe("converting multi line range to single line range", function()
    local input = [[
poem:
Every day is a beautiful day.
Some other day is not something beautiful.]]

    it("converts `start_row, start_col, end_row, end_col` to `start, _end`", function()
        module.myfunc(input)

        -- local start_row, start_col, end_row, end_col = 2, 1, 2, 5

        -- local want = { 7, 11 }
    end)

    it("multi line vs single line demonstration", function()
        local expected =
            "poem:\nEvery day is a beautiful day.\nSome other day is not something beautiful."

        assert.are.same(expected, input)
    end)

    it("string:sub() demonstration", function()
        assert.are.same("poem", input:sub(1, 4))

        -- \n is 1 single character, hence 7 not 8 to start `Every`
        assert.are.same("Every", input:sub(7, 11))
    end)

    it("string:find() demonstration", function()
        local find_start, find_end = input:find("day")
        assert.equal(find_start, 13)
        assert.equal(find_end, 15)

        local find_start, find_end = input:find("day", 15)
        assert.equal(find_start, 32)
        assert.equal(find_end, 34)

        local find_start, find_end = input:find("day", 34)
        assert.equal(find_start, 48)
        assert.equal(find_end, 50)
    end)
end)
