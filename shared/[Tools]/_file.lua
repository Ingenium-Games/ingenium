-- ====================================================================================--

c.file = {}

-- ====================================================================================--

--- func desc
---@param . any
function c.file.Exists(file)
    local f, err = io.open(GetResourcePath(GetCurrentResourceName()).."/data/"..file, "r")
    if not f then c.func.Debug_1(err) end
    if f then f:close() f = true else f = false end
    return f
end

--- func desc
---@param file any
function c.file.Read(file)
    local f, err = io.open(GetResourcePath(GetCurrentResourceName()).."/data/"..file, "r")
    if not f then c.func.Debug_1(err) end
    local data = f:read("a")
    f:close()
    return data
end
  
-- Write a string to a file.
--- func desc
---@param file any
---@param data any
function c.file.Write(file, data)
    local f, err = io.open(GetResourcePath(GetCurrentResourceName()).."/data/"..file,  "w+")
    if not f then c.func.Debug_1(err) end
    f:write(data)
    f:flush()
    f:close()
end

-- Write a string to a file.
--- func desc
---@param file any
---@param data any
function c.file.Append(file, data)
    local f, err = io.open(GetResourcePath(GetCurrentResourceName()).."/data/"..file,  "a")
    if not f then c.func.Debug_1(err) end
    f:write(data)
    f:flush()
    f:close()
end