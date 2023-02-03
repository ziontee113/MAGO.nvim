local module = require("MAGO.lib.lua_experimental")

describe("some Lua string replacement methods", function()
    it("works for single line case", function()
        local original_input = "Hello from Earth"
        local session = module.MagicSession:new(original_input)

        local first_range = { 1, 1, 1, 5 } -- Hello
        assert.equals("{} from Earth", session:replace_range(first_range))

        -- local second_range = { 1, 12, 1, 16 } -- Earth
        -- assert.equals("{} from {}", session:replace_range(second_range))
    end)
end)
