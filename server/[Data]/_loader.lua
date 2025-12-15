-- ====================================================================================--
c.json = c.json or {}
-- ====================================================================================--

--- Load JSON file from data directory
---@param filename string "File name in data/ directory"
---@return table|nil
function c.json.Load(filename)
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
function c.json.Write(filename, data)
    local resourceName = GetCurrentResourceName()
    local path = ('data/%s.json'):format(filename)
    local encoded = json.encode(data, {indent = true})
    
    SaveResourceFile(resourceName, path, encoded, -1)
    print(('^3[Data] Saved %s (%d bytes)^7'):format(path, #encoded))
end

--- Load data from JSON or fallback to defaults
--- This function is called during initialization and runs synchronously
---@param callback function Optional callback to execute after loading
function c.data.LoadJSONData(callback)
    print('^3[Data] Loading dynamic JSON files into memory...^7')
    
    -- Note: Static data (Items, Doors) are defined in their respective Lua files
    -- and written to JSON during script load. They don't need to be loaded here.
    
    -- Dynamic runtime data (loaded and saved periodically)
    -- If JSON doesn't exist, initialize with empty tables
    c.drops = c.json.Load('Drops') or {}
    c.picks = c.json.Load('Pickups') or {}
    c.scenes = c.json.Load('Scenes') or {}
    c.notes = c.json.Load('Notes') or {}
    c.gsrs = c.json.Load('GSR') or {}
    
    print('^2[Data] Dynamic JSON data loading complete^7')
    
    if callback then callback() end
end
