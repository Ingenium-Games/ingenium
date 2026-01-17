-- ====================================================================================--
-- Table utilities (ig.table initialized in shared/_ig.lua)
-- ====================================================================================--

--- Check if a value exists in a sequential array table
--- Optimized for sequential arrays with numeric indices (1, 2, 3...)
--- For sparse arrays or dictionaries, manually iterate with pairs()
---@param t table The array table to search
---@param v any The value to find
---@return boolean True if value exists in the table
function ig.table.MatchValue(t, v)
    -- Use ipairs for array iteration - faster than pairs for sequential arrays
    for _, i in ipairs(t) do
        if i == v then
            return true
        end
    end
    return false
end

--- Check if a key exists in a table
--- Works with both sequential arrays and associative tables (dictionaries)
--- Performance note: For simple key checks, t[k] ~= nil is faster
--- Use this function when you need consistent behavior across table types
--- For optimal array bounds checking, use: k >= 1 and k <= #t and t[k] ~= nil
---@param t table The table to check
---@param k any The key to find
---@return boolean True if key exists in the table
function ig.table.MatchKey(t, k)
    -- Use pairs for general key lookup (works for both arrays and dictionaries)
    for key, _ in pairs(t) do
        if key == k then
            return true
        end
    end
    return false
end

--- Creates a shallow copy of a table with its metatable
---@param t table "Table to clone"
---@return table Cloned table
function ig.table.Clone(t)
    local u = setmetatable({}, getmetatable(t))
    for i, v in pairs(t) do
        u[i] = v
    end
    return u
end


---@param t table "The original table"
---@param u table "The table to bring into the original"
---@param bool boolean "keep or replace?""
function ig.table.Merge(t, u, bool)
    if not bool then bool = true end
    local r = ig.table.Clone(t)
    if bool then
        for i, v in pairs(u) do
            if not r[i] then
                r[i] = v
            end
        end
    else
        for i, v in pairs(u) do
            r[i] = v
        end
    end
    return r
end

--- Rearranges table keys according to a mapping table
---@param p table "Mapping table with old->new key associations"
---@param t table "Table to rearrange"
---@return table New table with rearranged keys
function ig.table.ReArrange(p, t)
    local r = ig.table.Clone(t)
    for i, v in pairs(p) do
        r[v] = t[i]
        r[i] = nil
    end
    return r
end

--- Returns the size (length) of an array table using # operator
---@param t table "Array table to measure"
---@return integer Number of elements
function ig.table.Size(t)
    local r = #t
    return r
end

--- Counts all key-value pairs in a table (works for dictionaries and sparse arrays)
---@param t table "Table to count"
---@return integer Total number of key-value pairs
function ig.table.SizeOf(t)
	local count = 0

	for _,_ in pairs(t) do
		count = count + 1
	end

	return count
end

--- Flexible count function - counts keys or occurrences of a value
--- If no value provided, counts total keys (same as SizeOf)
--- If value provided, counts how many times that value appears
---@param t table "Table to count in"
---@param value any|nil "Optional: specific value to count occurrences of"
---@return integer Count of keys or value occurrences
function ig.table.Count(t, value)
    if not t then return 0 end
    
    -- If no value specified, count all keys
    if value == nil then
        local count = 0
        for _ in pairs(t) do
            count = count + 1
        end
        return count
    end
    
    -- Count occurrences of specific value
    local count = 0
    for _, v in pairs(t) do
        if v == value then
            count = count + 1
        end
    end
    return count
end

--- Recursively converts a table to a formatted string representation for debugging
---@param table table "Table to dump"
---@param nb integer|nil "Indentation level (optional, defaults to 0)"
---@return string Formatted string representation of table
function ig.table.Dump(table, nb)
    if nb == nil then
        nb = 0
    end

    if type(table) == "table" then
        local s = ""
        for i = 1, nb + 1, 1 do
            s = s .. "    "
        end

        s = "{\n"
        for k, v in pairs(table) do
            if type(k) ~= "number" then
                k = "'" .. k .. "'"
            end
            for i = 1, nb, 1 do
                s = s .. "    "
            end
            s = s .. "[" .. k .. "] = " .. ig.table.Dump(v, nb + 1) .. ",\n"
        end

        for i = 1, nb, 1 do
            s = s .. "    "
        end

        return s .. "}"
    else
        return tostring(table)
    end
end


--- Convert read-only table (or any table with metatables) to plain serializable table
--- Required for json.encode() which cannot serialize tables with metatables
---@param tbl table The table to convert (can be read-only proxy or regular table)
---@return table Plain table without metatables, safe for JSON serialization
function ig.table.Convert2Plain(tbl)
    if not tbl or type(tbl) ~= "table" then
        return tbl
    end
    
    local plain = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            plain[k] = ig.table.Convert2Plain(v)  -- Recursive for nested tables
        else
            plain[k] = v
        end
    end
    return plain
end

--- Makes a table read-only by preventing modifications
--- Recursively protects nested tables as well
---@param t table The table to make read-only
---@param name string|nil Optional name for error messages
---@return table The read-only proxy table
function ig.table.MakeReadOnly(t, name)
    if type(t) ~= "table" then
        return t
    end
    
    -- Cache for protected nested tables to avoid repeated metatable creation
    -- MUST be declared before the metatable to be captured in the closure
    local nestedProxies = {}
    
    -- Create metatable for read-only access
    local mt = {
        __index = function(_, key)
            local value = t[key]
            -- Recursively protect nested tables
            if type(value) == "table" then
                -- Cache the protected nested table
                if not nestedProxies[key] then
                    nestedProxies[key] = ig.table.MakeReadOnly(value, name and (name .. "." .. tostring(key)) or tostring(key))
                end
                return nestedProxies[key]
            end
            return value
        end,
        __newindex = function(_, key, _)
            local tableName = name or "table"
            error(string.format("Attempt to modify read-only %s[%s]. This data is protected from modification.", tableName, tostring(key)), 2)
        end,
        __metatable = "protected",
        __pairs = function()
            return pairs(t)
        end,
        __ipairs = function()
            return ipairs(t)
        end
    }
    
    -- Create and return the proxy table with the metatable
    return setmetatable({}, mt)
end

-- ====================================================================================--
