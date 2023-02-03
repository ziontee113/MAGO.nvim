local M = {}

M.myfunc = function(input)
    local positions = {}

    local first, last = 0, nil
    while true do
        first, last = input:find("\n", first + 1)

        table.insert(positions, { first, last })

        if not first then
            break
        end
    end
end

return M
