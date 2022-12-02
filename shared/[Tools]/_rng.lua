-- ====================================================================================--
c.rng = {}
-- ====================================================================================--

--- func desc
---@param . any
function c.rng.num()
    local rand = math.random(0, 9)
    return rand
end

--- func desc
function c.rng.let()
    local rand = string.char(math.random(97, 122))
    return rand
end

--- func desc
function c.rng.char()
    local rand = nil
    local rlet = c.rng.let()
    local rnum = c.rng.num()
    if math.random(0, 9) > 4 then
        rand = rnum
    else
        rand = rlet
    end
    return rand
end

--- func desc
---@param num any
function c.rng.nums(num)
    local rand = nil
    local len = num
    local temp = {}
    if rand == nil then
        for i = 1, len do
            if math.random(0, 9) > 4 then
                table.insert(temp, c.rng.num())
            else
                table.insert(temp, c.rng.num())
            end
        end

        rand = tostring(table.concat(temp))
    end
    return rand
end

--- func desc
---@param num any
function c.rng.lets(num)
    local rand = nil
    local len = num
    local temp = {}
    if rand == nil then
        for i = 1, len do
            if math.random(0, 9) > 4 then
                table.insert(temp, c.rng.let())
            else
                table.insert(temp, c.rng.let())
            end
        end
        rand = tostring(table.concat(temp))
    end
    return rand
end

--- func desc
---@param num any
function c.rng.chars(num)
    local rand = nil
    local len = num
    local temp = {}
    if rand == nil then
        for i = 1, len do
            if math.random(0, 9) > 4 then
                table.insert(temp, c.rng.char())
            else
                table.insert(temp, c.rng.char())
            end
        end
        rand = tostring(table.concat(temp))
    end
    return rand
end

--- func desc
---@param min any
---@param max any
---@param amount any
function c.rng.RandomValuesNoRepeats(min,max,amount)
    if (max - min) <= amount then c.func.Debug_1("Unable to use values from [F] c.func.RandomValuesNoRepeats as min and max values do not allow for the amount required.") return end
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

function c.rng.UUID()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end