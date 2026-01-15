-- ====================================================================================--
-- Random number generation (ig.rng initialized in shared/_ig.lua)
-- ====================================================================================--

--- Generates a random single digit (0-9)
---@return integer Random digit between 0 and 9
function ig.rng.num()
    local rand = math.random(0, 9)
    return rand
end

--- func desc
function ig.rng.let()
    local rand = string.char(math.random(97, 122))
    return rand
end

--- func desc
function ig.rng.char()
    local rand = nil
    local rlet = ig.rng.let()
    local rnum = ig.rng.num()
    if math.random(0, 9) > 4 then
        rand = rnum
    else
        rand = rlet
    end
    return rand
end

--- Generates a random string of digits
---@param num integer "Number of digits to generate"
---@return string Random numeric string
function ig.rng.nums(num)
    local rand = nil
    local len = num
    local temp = {}
    if rand == nil then
        for i = 1, len do
            if math.random(0, 9) > 4 then
                table.insert(temp, ig.rng.num())
            else
                table.insert(temp, ig.rng.num())
            end
        end

        rand = tostring(table.concat(temp))
    end
    return rand
end

--- Generates a random string of lowercase letters
---@param num integer "Number of letters to generate"
---@return string Random letter string
function ig.rng.lets(num)
    local rand = nil
    local len = num
    local temp = {}
    if rand == nil then
        for i = 1, len do
            if math.random(0, 9) > 4 then
                table.insert(temp, ig.rng.let())
            else
                table.insert(temp, ig.rng.let())
            end
        end
        rand = tostring(table.concat(temp))
    end
    return rand
end

--- Generates a random string of mixed characters (digits and letters)
---@param num integer "Number of characters to generate"
---@return string Random mixed character string
function ig.rng.chars(num)
    local rand = nil
    local len = num
    local temp = {}
    if rand == nil then
        for i = 1, len do
            if math.random(0, 9) > 4 then
                table.insert(temp, ig.rng.char())
            else
                table.insert(temp, ig.rng.char())
            end
        end
        rand = tostring(table.concat(temp))
    end
    return rand
end

--- Generates unique random values within a range
---@param min integer "Minimum value (inclusive)"
---@param max integer "Maximum value (inclusive)"
---@param amount integer "Number of unique values to generate"
---@return table Array of unique random values
function ig.rng.RandomValuesNoRepeats(min,max,amount)
    if (max - min) <= amount then ig.log.Error("RNG", "Unable to use values for ig.func.RandomValuesNoRepeats - min and max values do not allow for the amount required") return end
    --
    local vars = {}
    repeat
        local new = math.random(min, max)
        if not vars[new] then
            table.insert(vars, new)
        end
    until #vars == amount
    return vars
end

-- ====================================================================================--

function ig.rng.UUID()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end