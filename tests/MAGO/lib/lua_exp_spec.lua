describe("some Lua string replacement methods", function()
    it("works for single line case", function()
        local original_input = "Hello from Earth"

        local first_range = { 1, 5 } -- Hello
        local second_range = { 12, 16 } -- Earth
        local ranges = { first_range, second_range }

        local want = "{} from {}"
        local got = magical_func(original_input, ranges)

        assert.equals(want, got)
    end)
end)
