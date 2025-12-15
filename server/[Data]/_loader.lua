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
    c.active_drops = {} -- Always start with no active drops
    c.picks = c.json.Load('Pickups') or {}
    c.scenes = c.json.Load('Scenes') or {}
    c.notes = c.json.Load('Notes') or {}
    c.gsrs = c.json.Load('GSR') or {}
    
    print('^2[Data] Dynamic JSON data loading complete^7')
    
    if callback then callback() end
end

--- Restore drops from JSON after server restart
function c.data.RestoreDrops()
    if not c.drops or type(c.drops) ~= "table" then
        c.func.Debug_1("No drops to restore")
        return
    end
    
    local restoredCount = 0
    local failedCount = 0
    
    for uuid, drop in pairs(c.drops) do
        if drop.Coords and drop.Model and drop.Inventory then
            -- Create the physical object
            local entity, netId = c.func.CreateObject(
                drop.Model,
                drop.Coords.x,
                drop.Coords.y,
                drop.Coords.z,
                false
            )
            
            if entity and netId then
                -- Get the object
                local xObject = c.data.GetObject(netId)
                if xObject then
                    -- Set coordinates
                    xObject.SetCoords({
                        x = drop.Coords.x,
                        y = drop.Coords.y,
                        z = drop.Coords.z,
                        h = drop.Coords.h or 0.0,
                        rx = 0.0,
                        ry = 0.0,
                        rz = 0.0
                    })
                    
                    -- Freeze and enable collision
                    FreezeEntityPosition(xObject.Entity, true)
                    SetEntityCollision(xObject.Entity, true, true)
                    
                    -- Add inventory items
                    if type(drop.Inventory) == "table" then
                        for _, item in ipairs(drop.Inventory) do
                            xObject.AddItem(item)
                        end
                    end
                    
                    -- Update state bag
                    xObject.State.Inventory = xObject.GetInventory()
                    
                    -- Update drop entry with new NetID
                    drop.NetID = netId
                    c.drops[uuid] = drop
                    
                    restoredCount = restoredCount + 1
                else
                    c.func.Debug_1("Failed to get xObject for restored drop: " .. uuid)
                    failedCount = failedCount + 1
                end
            else
                c.func.Debug_1("Failed to create entity for drop: " .. uuid)
                failedCount = failedCount + 1
            end
        else
            c.func.Debug_1("Invalid drop data for UUID: " .. uuid)
            failedCount = failedCount + 1
        end
    end
    
    if restoredCount > 0 then
        print(('^2[Drops] Restored %d drops from persistence^7'):format(restoredCount))
    end
    if failedCount > 0 then
        print(('^1[Drops] Failed to restore %d drops^7'):format(failedCount))
    end
end
