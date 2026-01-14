-- ====================================================================================--
ig.check = {}
-- ====================================================================================--
--- func desc
---@param num any
---@param min any
---@param max any
function ig.check.Number(num, min, max)
    local v = 0
    if min and max then
        if type(num) ~= "number" then
            return v
        else
            -- Check for NaN (NaN != NaN in Lua)
            if num ~= num then
                return v
            end
            -- Explicit clamping: ensure value is within min-max range
            return math.max(min, math.min(max, num))
        end
    else
        if type(num) ~= "number" then
            return v
        else
            -- Check for NaN (NaN != NaN in Lua)
            if num ~= num then
                return v
            end
            return num
        end
    end
end

--- Validates and returns a boolean value, asserts if type is invalid
---@param bool boolean "Boolean value to validate"
---@return boolean
function ig.check.Boolean(bool)
    local v = false
    assert(type(bool) == "boolean", "Invalid variable type at argument #1, expected boolean, got "..type(bool))
    if type(bool) ~= "boolean" then
        return v
    else
        return bool
    end
end

--- Validates and returns a table, asserts if type is invalid
---@param t table "Table to validate"
---@return table
function ig.check.Table(t)
    local v = {}
    assert(type(t) == "table", "Invalid variable type at argument #1, expected table, got "..type(t))
    if type(t) ~= "table" then
        return v
    else
        return t
    end
end

--- Validates and returns a string value, asserts if type is invalid
---@param str string "String to validate"
---@return string
function ig.check.String(str)
    local v = ""
    assert(type(str) == "string", "Invalid variable type at argument #1, expected string, got "..type(str))
    if type(str) ~= "string" then
        return v
    else
        return str
    end
end