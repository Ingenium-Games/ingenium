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

-- Load all static data on resource start
CreateThread(function()
    print('^3[Data] Loading JSON files into memory...^7')
    
    -- Static reference data (loaded once, never modified)
    c.items = c.json.Load('Items') or {}
    c.doors = c.json.Load('Doors') or {}
    c.names = c.json.Load('Names') or {}
    c.jobs_data = c.json.Load('Jobs') or {}
    
    -- Dynamic runtime data (loaded and saved periodically)
    c.drops = c.json.Load('Drops') or {}
    c.picks = c.json.Load('Pickups') or {}
    c.scenes = c.json.Load('Scenes') or {}
    c.notes = c.json.Load('Notes') or {}
    c.gsrs = c.json.Load('GSR') or {}
    
    -- Count items loaded
    local itemCount = 0
    for _ in pairs(c.items) do itemCount = itemCount + 1 end
    
    local doorCount = 0
    for _ in pairs(c.doors) do doorCount = doorCount + 1 end
    
    print(('^2[Data] Loaded %d items, %d doors into memory^7'):format(itemCount, doorCount))
    print('^2[Data] All JSON files loaded successfully^7')
end)
