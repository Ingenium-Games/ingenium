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
        ig.log.Error('Data', 'Failed to load %s', path)
        return nil
    end
    
    local success, data = pcall(json.decode, file)
    if not success then
        ig.log.Error('Data', 'Failed to decode %s: %s', path, data)
        return nil
    end

    ig.log.Info('Data', 'Loaded %s (%d bytes)', path, #file)
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
    ig.log.Info('Data', 'Saved %s (%d bytes)', path, #encoded)
end