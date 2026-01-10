-- ====================================================================================--
ig.data = {} -- data table for funcitons.
-- ====================================================================================--


-- ====================================================================================--
-- 


-- ====================================================================================--
-- Jobs - ig.jdex = Object table, ig.jobs = table built from the DB, ig.job = functions.

--- func desc
function ig.data.CreateJobObjects()
    local jobs = ig.job.GetJobs()
    for k, v in pairs(jobs) do
        if not ig.jdex[k] then
            ig.jdex[k] = ig.class.Job(v)
        end
    end
    ig.json.Write(conf.file.jobs, ig.jobs)
end

--- func desc
function ig.data.GetJobs()
    return ig.jdex
end

--- func desc
---@param str any
function ig.data.GetJob(str)
    return ig.jdex[str]
end

-- ====================================================================================--

--- Used on startup prior to the server really running.
function ig.data.Initilize()
    --
    ig._loading = true
    print('^3[Initialization] Waiting for SQL connection...^7')
    --
    -- Wait for SQL to be ready with proper timeout
    local sqlReady = ig.sql.AwaitReady(40000)
    
    if not sqlReady then
        print('^1[CRITICAL] SQL connection failed to initialize within 40 seconds!^7')
        print('^1[CRITICAL] Server initialization aborted. Please check MySQL configuration.^7')
        return
    end
    
    print('^2[Initialization] SQL connection ready^7')
    --
    ig.data.LoadJSONData(function()
        ig.item.GenerateConsumptionEvents()
        print(('  ^3- Consumption Events: Registered^7')) 
        --
        ig.data.RestoreDrops()
        print(('  ^3- Restoring: Drops^7')) 
    end)
    --
    ig._loading = false
    ig._dataloaded = true
    print('^2[Initialization] Server data initialization complete^7')
end


--- func desc
---@param str any
function ig.data.Save(str)

end

-- Server to Datatable routine.
function ig.data.RetrievePackets()
    local plys = ig.data.GetPlayers()
    for k, v in pairs(plys) do
        if v then
            local data = TriggerClientCallback({
                source = k,
                eventName = "DataPacket",
                args = {}
            })
            if data then
                local xPlayer = ig.data.GetPlayer(k)
                xPlayer.SetHealth(data.Health)
                xPlayer.SetArmour(data.Armour)
                xPlayer.SetHunger(data.Hunger)
                xPlayer.SetThirst(data.Thirst)
                xPlayer.SetStress(data.Stress)
                xPlayer.SetModifiers(data.Modifiers)
            end
        end
    end
end

--- func desc
function ig.data.CharacterValues()
    local function Do()
        ig.data.RetrievePackets()
        SetTimeout(conf.charactersync, Do)
    end
    SetTimeout(conf.charactersync, Do)
end

-- Server to DB routine - Consolidated save manager
-- Uses a single timeout chain with timer-based scheduling to reduce thread overhead
function ig.data.ServerSync()
    -- Track last run time for each save type
    local lastRun = {
        users = 0,
        vehicles = 0,
        jobs = 0,
        objects = 0
    }
    
    -- Consolidated save loop - runs at the smallest interval and checks what needs saving
    local function ConsolidatedSaveLoop()
        if ig.data.ArePlayersActive() ~= nil then
            local currentTime = os.clock()
            
            -- User sync - most frequent (1.5 min)
            if (currentTime - lastRun.users) >= (conf.serversync / 1000) then
                ig.sql.save.Users()
                lastRun.users = currentTime
            end
            
            -- Vehicle sync - less frequent (5 min)
            if (currentTime - lastRun.vehicles) >= (conf.vehiclesync / 1000) then
                ig.sql.save.Vehicles()
                lastRun.vehicles = currentTime
            end
            
            -- Job sync - least frequent (10 min)
            if (currentTime - lastRun.jobs) >= (conf.jobsync / 1000) then
                ig.sql.save.Jobs()
                lastRun.jobs = currentTime
            end
            
            -- Object sync - moderate frequency (5 min)
            if (currentTime - lastRun.objects) >= (conf.objectsync / 1000) then
                ig.sql.save.Objects()
                lastRun.objects = currentTime
            end
        end
        
        -- Use the smallest interval as our check frequency (serversync is typically the smallest)
        SetTimeout(conf.serversync, ConsolidatedSaveLoop)
    end
    
    -- Start the consolidated save loop
    SetTimeout(conf.serversync, ConsolidatedSaveLoop)
    ig.func.Debug_1("Consolidated save manager started")
end

-- Server to DB routine.
function ig.data.ReviveSync()
    local function Do()
        local result = ig.sql.char.ReviveDeadCharacters()
        if result then
            ig.func.Debug_2("Revived Characters")
        end
        SetTimeout(conf.revivesync, Do)
    end
    SetTimeout(conf.revivesync, Do)
end

-- ====================================================================================--

--- Create xPlayer table and pass to client.
---@param source number
---@param Character_ID string
function ig.data.LoadPlayer(source, Character_ID)
    local src = tonumber(source)
    local p = promise.new()
    local xPlayer = ig.class.Player(src, Character_ID)
    -- No need to pass data to the client anymore.
    ig.sql.char.SetActive(Character_ID, true, function()
        ig.data.SetPlayer(src, xPlayer)
        p:resolve()
    end)
    -- Wait for the player to be loaded prior to sending the "ok" to load to the client.
    Citizen.Await(p)
    TriggerClientEvent("Client:Character:Loaded", src)
end

-- ====================================================================================--

--- Load data from JSON or fallback to defaults
--- This function is called during initialization and runs synchronously
---@param callback function Optional callback to execute after loading
function ig.data.LoadJSONData(callback)
    print('^3[Data] Loading dynamic and static JSON files into memory...^7')

    -- ==== DYNAMIC ("Runtime") DATA TABLES ====
    ig.items        = ig.json.Load('items') or {}
    ig.drops        = ig.json.Load('drops') or {}
    ig.active_drops = {}  -- always reset
    ig.picks        = ig.json.Load('pickups') or {}
    ig.scenes       = ig.json.Load('scenes') or {}
    ig.notes        = ig.json.Load('notes') or {}
    ig.gsrs         = ig.json.Load('gsr') or {}
    ig.jobs         = ig.json.Load('jobs') or {}
    ig.doors        = ig.json.Load('doors') or {}
    ig.objects      = ig.json.Load('objects') or {}
    ig.names        = ig.json.Load('names') or {}

    -- ==== STATIC ("Reference") DATA TABLES ("ig.dump"/config) ====
    ig.tattoos             = ig.json.Load('tattoos') or {}
    ig.weapons             = ig.json.Load('weapons') or {}
    ig.vehicles            = ig.json.Load('vehicles') or {}
    ig.modkits             = ig.json.Load('modkits') or {}
    ig.peds                = ig.json.Load('peds') or {}
    ig.appearance_constants= ig.json.Load('appearance-constants') or {}

    -- Output counts for verification
    local counts = {
        items = 0, drops = 0, picks = 0, scenes = 0, notes = 0, gsrs = 0, jobs = 0, doors = 0, objects = 0, names = 0,
        tattoos = 0, weapons = 0, vehicles = 0, modkits = 0, peds = 0,
    }

    for _ in pairs(ig.items)     do counts.items = counts.items + 1 end
    for _ in pairs(ig.drops)     do counts.drops = counts.drops + 1 end
    for _ in pairs(ig.picks)     do counts.picks = counts.picks + 1 end
    for _ in pairs(ig.scenes)    do counts.scenes = counts.scenes + 1 end
    for _ in pairs(ig.notes)     do counts.notes = counts.notes + 1 end
    for _ in pairs(ig.gsrs)      do counts.gsrs = counts.gsrs + 1 end
    for _ in pairs(ig.jobs)      do counts.jobs = counts.jobs + 1 end
    for _ in pairs(ig.doors)     do counts.doors = counts.doors + 1 end
    for _ in pairs(ig.objects)   do counts.objects = counts.objects + 1 end
    for _ in pairs(ig.names)     do counts.names = counts.names + 1 end

    for _ in pairs(ig.tattoos)   do counts.tattoos = counts.tattoos + 1 end
    for _ in pairs(ig.weapons)   do counts.weapons = counts.weapons + 1 end
    for _ in pairs(ig.vehicles)  do counts.vehicles = counts.vehicles + 1 end
    for _ in pairs(ig.modkits)   do counts.modkits = counts.modkits + 1 end
    for _ in pairs(ig.peds)      do counts.peds = counts.peds + 1 end

    print('^2[Data] Dynamic runtime data loaded:^7')
    print(('  ^3- Items: %d^7'):format(counts.items))
    print(('  ^3- Drops: %d^7'):format(counts.drops))
    print(('  ^3- Pickups: %d^7'):format(counts.picks))
    print(('  ^3- Scenes: %d^7'):format(counts.scenes))
    print(('  ^3- Notes: %d^7'):format(counts.notes))
    print(('  ^3- GSR Entries: %d^7'):format(counts.gsrs))
    print(('  ^3- Jobs: %d^7'):format(counts.jobs))
    print(('  ^3- Doors: %d^7'):format(counts.doors))
    print(('  ^3- Objects: %d^7'):format(counts.objects))
    print(('  ^3- Names: %d^7'):format(counts.names))

    print('^2[Data] Static reference data loaded:^7')
    print(('  ^3- Tattoos: %d^7'):format(counts.tattoos))
    print(('  ^3- Weapons: %d^7'):format(counts.weapons))
    print(('  ^3- Vehicles: %d^7'):format(counts.vehicles))
    print(('  ^3- Modkits: %d^7'):format(counts.modkits))
    print(('  ^3- Peds: %d^7'):format(counts.peds))
    if ig.appearance_constants and next(ig.appearance_constants) then 
        print('  ^3- Appearance Constants: Loaded^7') 
    end

    print('^2[Data] JSON data loading complete^7')

    -- Protect static reference data from modification
    -- These tables should NEVER be modified at runtime
    -- Dynamic tables (items, drops, jobs, doors, objects, etc.) are intentionally left
    -- unprotected as they need to be modified during gameplay
    ig.tattoos = ig.table.MakeReadOnly(ig.tattoos, "ig.tattoos")
    ig.weapons = ig.table.MakeReadOnly(ig.weapons, "ig.weapons")
    ig.vehicles = ig.table.MakeReadOnly(ig.vehicles, "ig.vehicles")
    ig.modkits = ig.table.MakeReadOnly(ig.modkits, "ig.modkits")
    ig.peds = ig.table.MakeReadOnly(ig.peds, "ig.peds")
    ig.appearance_constants = ig.table.MakeReadOnly(ig.appearance_constants, "ig.appearance_constants")
    
    print('^2[Data] Static reference data protected from modification^7')

    if callback then callback() end
end

--- Restore drops from JSON after server restart
function ig.data.RestoreDrops()
    if not ig.drops or type(ig.drops) ~= "table" then
        ig.func.Debug_1("No drops to restore")
        return
    end
    
    local restoredCount = 0
    local failedCount = 0
    
    for uuid, drop in pairs(ig.drops) do
        if drop.Coords and drop.Model and drop.Inventory then
            -- Create the physical object
            local entity, netId = ig.func.CreateObject(
                drop.Model,
                drop.Coords.x,
                drop.Coords.y,
                drop.Coords.z,
                false,
                drop
            )
            
            if entity and netId then
                -- Get the object
                local xObject = ig.data.GetObject(netId)
                if xObject then
                    -- Freeze and enable collision
                    FreezeEntityPosition(xObject.Entity, true)
                    SetEntityCollision(xObject.Entity, true, true)
                    --
                    restoredCount = restoredCount + 1
                else
                    ig.func.Debug_1("Failed to get xObject for restored drop: " .. uuid)
                    failedCount = failedCount + 1
                end
            else
                ig.func.Debug_1("Failed to create entity for drop: " .. uuid)
                failedCount = failedCount + 1
            end
        else
            ig.func.Debug_1("Invalid drop data for UUID: " .. uuid)
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

-- ====================================================================================--
-- Player Data Functions (Wrappers for ig.player)
-- ====================================================================================--

--- Get all players
function ig.data.GetPlayers()
    return ig.player.GetPlayers()
end

--- Get a player by source
---@param src number
function ig.data.GetPlayer(src)
    return ig.player.GetPlayer(src)
end

--- Set player data
---@param src number
---@param data table
function ig.data.SetPlayer(src, data)
    ig.player.SetPlayer(src, data)
end

--- Add a player
---@param src number
function ig.data.AddPlayer(src)
    ig.player.AddPlayer(src)
end

--- Remove a player
---@param src number
function ig.data.RemovePlayer(src)
    ig.player.RemovePlayer(src)
end

--- Get player by Character_ID
---@param characterId string
function ig.data.GetPlayerByCharacterId(characterId)
    return ig.player.GetPlayerByCharacterId(characterId)
end
