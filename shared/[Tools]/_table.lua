-- ====================================================================================--
ig.table = {}
-- ====================================================================================--

--- func desc
---@param . any
function ig.table.MatchValue(t, v)
    for _, i in ipairs(t) do
        if (i == v) then
            return true
        end
    end
    return false
end

--- func desc
---@param t any
---@param k any
function ig.table.MatchKey(t, k)
    for i, _ in ipairs(t) do
        if (i == k) then
            return true
        end
    end
    return false
end

--- func desc
---@param t any
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

--- func desc
---@param p any
---@param t any
function ig.table.ReArrange(p, t)
    local r = ig.table.Clone(t)
    for i, v in pairs(p) do
        r[v] = t[i]
        r[i] = nil
    end
    return r
end

--- func desc
---@param t any
function ig.table.Size(t)
    local r = #t
    return r
end

--- func desc
---@param t any
function ig.table.SizeOf(t)
	local count = 0

	for _,_ in pairs(t) do
		count = count + 1
	end

	return count
end

--- func desc
---@param table any
---@param nb any
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

--- Makes a table read-only by preventing modifications
--- Recursively protects nested tables as well
---@param t table "The table to make read-only"
---@param name string|nil "Optional name for error messages"
---@return table "The read-only proxy table"
function ig.table.MakeReadOnly(t, name)
    if type(t) ~= "table" then
        return t
    end
    
    -- Create a proxy table
    local proxy = {}
    
    -- Create metatable for read-only access
    local mt = {
        __index = function(_, key)
            local value = t[key]
            -- Recursively protect nested tables
            if type(value) == "table" then
                return ig.table.MakeReadOnly(value, name and (name .. "." .. tostring(key)) or tostring(key))
            end
            return value
        end,
        __newindex = function(_, key, value)
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
    
    setmetatable(proxy, mt)
    return proxy
end

-- ====================================================================================--
