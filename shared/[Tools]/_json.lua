-- ====================================================================================--
ig.json = {}
-- ====================================================================================--

--- Load JSON file from data directory
---@param filename string "File name in data/ directory"
---@return table|nil
function ig.json.Load(filename)
    local resourceName = GetCurrentResourceName()
    local path = ('data/%s.json'):format(filename)
    local file = LoadResourceFile(resourceName, path)
    
    if not file then
        print(('^1[ERROR] Failed to load %s^7'):format(path))
        return nil
    end
    
    local success, data = pcall(json.decode, file)
    if not success then
        print(('^1[ERROR] Failed to decode %s: %s^7'):format(path, data))
        return nil
    end
    
    print(('^2[Data] Loaded %s (%d bytes)^7'):format(path, #file))
    return data
end

--- Write JSON file to data directory
---@param filename string
---@param data table
function ig.json.Write(filename, data)
    local resourceName = GetCurrentResourceName()
    local path = ('data/%s.json'):format(filename)
    local encoded = json.encode(data, {indent = true})
    
    SaveResourceFile(resourceName, path, encoded, -1)
    print(('^3[Data] Saved %s (%d bytes)^7'):format(path, #encoded))
end