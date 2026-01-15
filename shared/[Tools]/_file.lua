-- ====================================================================================--
-- File operations (ig.file initialized in shared/_ig.lua)
-- ====================================================================================--
--- Checks if a file exists in the data directory
---@param file string "File name (without data/ prefix)"
---@return boolean True if file exists
function ig.file.Exists(file)
    local f, err = io.open(GetResourcePath(GetCurrentResourceName()).."/data/"..file, "r")
    if not f then ig.log.Error("File", err) end
    if f then f:close() f = true else f = false end
    return f
end

--- Reads the entire contents of a file from the data directory
---@param file string "File name (without data/ prefix)"
---@return string|nil File contents or nil if error
function ig.file.Read(file)
    local f, err = io.open(GetResourcePath(GetCurrentResourceName()).."/data/"..file, "r")
    if not f then ig.log.Error("File", err) end
    local data = f:read("a")
    f:close()
    return data
end
  
--- Writes data to a file in the data directory (overwrites existing content)
---@param file string "File name (without data/ prefix)"
---@param data string "Content to write"
function ig.file.Write(file, data)
    local f, err = io.open(GetResourcePath(GetCurrentResourceName()).."/data/"..file,  "w+")
    if not f then ig.log.Error("File", err) end
    f:write(data)
    f:flush()
    f:close()
end

--- Appends data to a file in the data directory (creates if not exists)
---@param file string "File name (without data/ prefix)"
---@param data string "Content to append"
function ig.file.Append(file, data)
    local f, err = io.open(GetResourcePath(GetCurrentResourceName()).."/data/"..file,  "a")
    if not f then ig.log.Error("File", err) end
    f:write(data)
    f:flush()
    f:close()
end