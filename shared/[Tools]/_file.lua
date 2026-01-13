-- ====================================================================================--
ig.file = {}
-- ====================================================================================--
--- func desc
---@param . any
function ig.file.Exists(file)
    local f, err = io.open(GetResourcePath(GetCurrentResourceName()).."/data/"..file, "r")
    if not f then ig.log.Error("File", err) end
    if f then f:close() f = true else f = false end
    return f
end

--- func desc
---@param file any
function ig.file.Read(file)
    local f, err = io.open(GetResourcePath(GetCurrentResourceName()).."/data/"..file, "r")
    if not f then ig.log.Error("File", err) end
    local data = f:read("a")
    f:close()
    return data
end
  
-- Write a string to a file.
--- func desc
---@param file any
---@param data any
function ig.file.Write(file, data)
    local f, err = io.open(GetResourcePath(GetCurrentResourceName()).."/data/"..file,  "w+")
    if not f then ig.log.Error("File", err) end
    f:write(data)
    f:flush()
    f:close()
end

-- Write a string to a file.
--- func desc
---@param file any
---@param data any
function ig.file.Append(file, data)
    local f, err = io.open(GetResourcePath(GetCurrentResourceName()).."/data/"..file,  "a")
    if not f then ig.log.Error("File", err) end
    f:write(data)
    f:flush()
    f:close()
end