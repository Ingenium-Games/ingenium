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
    
    -- Game data (static reference data from ig.dump)
    c.tattoos = c.json.Load('tattoos') or {}
    c.weapons = c.json.Load('weapons') or {}
    c.vehicles = c.json.Load('vehicles') or {}
    c.modkits = c.json.Load('modkits') or {}
    
    -- Count loaded items
    local counts = {
        tattoos = 0,
        weapons = 0,
        vehicles = 0,
        modkits = 0
    }
    for _ in pairs(c.tattoos) do counts.tattoos = counts.tattoos + 1 end
    for _ in pairs(c.weapons) do counts.weapons = counts.weapons + 1 end
    for _ in pairs(c.vehicles) do counts.vehicles = counts.vehicles + 1 end
    for _ in pairs(c.modkits) do counts.modkits = counts.modkits + 1 end
    
    if counts.tattoos > 0 or counts.weapons > 0 or counts.vehicles > 0 or counts.modkits > 0 then
        print('^2[Data] Game data loaded:^7')
        if counts.tattoos > 0 then print(('  ^3- Tattoos: %d^7'):format(counts.tattoos)) end
        if counts.weapons > 0 then print(('  ^3- Weapons: %d^7'):format(counts.weapons)) end
        if counts.vehicles > 0 then print(('  ^3- Vehicles: %d^7'):format(counts.vehicles)) end
        if counts.modkits > 0 then print(('  ^3- Mod Kits: %d^7'):format(counts.modkits)) end
    end
    
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
                    
                    -- Add inventory items with validation
                    if type(drop.Inventory) == "table" then
                        for _, item in ipairs(drop.Inventory) do
                            -- Validate item exists in the database before adding
                            local itemName = item[1] or item.Item
                            if itemName and c.item.Exists(itemName) then
                                xObject.AddItem(item)
                            else
                                c.func.Debug_1("Skipping invalid item in drop restore: " .. tostring(itemName))
                            end
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
