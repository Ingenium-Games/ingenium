-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
c.rng = {}
--[[
NOTES.
    -
    -
    -
]] --

-- ====================================================================================--

function c.rng.num()
    local rand = math.random(0, 9)
    return rand
end

function c.rng.let()
    local rand = string.char(math.random(97, 122))
    return rand
end

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

-- ====================================================================================--
