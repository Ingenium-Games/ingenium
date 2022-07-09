-- ====================================================================================--

c.check = {}
--[[
NOTES.
    -
    -
    -
]] --

-- ====================================================================================--

function c.check.Number(num, min, max)
    local v = 0
    if min and max then
        assert(type(num) == "number", "Invalid variable type at argument #1, expected number, got "..type(num))
        if type(num) ~= "number" or num == nil then
            return v
        else
            if num >= min and num <= max then
                return num
            else
                c.func.Debug_1("Unable to add value lesser than "..min..", or greater than"..max..". Returned 0.")
                return v
            end
        end
    else
        assert(type(num) == "number", "Invalid variable type at argument #1, expected number, got "..type(num))
        if type(num) ~= "number" then
            return v
        else
            return num
        end
    end
end

function c.check.Boolean(bool)
    local v = false
    assert(type(bool) == "boolean", "Invalid variable type at argument #1, expected boolean, got "..type(bool))
    if type(bool) ~= "boolean" then
        return v
    else
        return bool
    end
end

function c.check.Table(t)
    local v = {}
    assert(type(t) == "table", "Invalid variable type at argument #1, expected table, got "..type(t))
    if type(t) ~= "table" then
        return v
    else
        return t
    end
end

function c.check.String(str)
    local v = ""
    assert(type(str) == "string", "Invalid variable type at argument #1, expected string, got "..type(str))
    if type(str) ~= "string" then
        return v
    else
        return str
    end
end