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

--- func desc
---@param str any
function ig.GetJob(str)
    return ig.data.GetJob(str)
end

-- ====================================================================================--

--- Used on startup prior to the server really running.
function ig.data.Initilize()
    --
    ig._loading = true
    --
    ig.sql.AwaitReady(40000, function()
        --
        ig._loading = false
        --
    end)

    while ig._loading do
        Wait(250)
    end
    --
    ig.data.LoadJSONData(function()
        ig.item.GenerateConsumptionEvents()
        print(('  ^3- Consumption Events: Registered^7')) 
        --
        ig.data.RestoreDrops()
        print(('  ^3- Restoring: Drops^7')) 
    end)
    --
    ig._dataloaded = true
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

-- Server to DB routine.
function ig.data.ServerSync()
    -- Separate sync threads for different data types with different intervals
    
    -- User sync - most frequent (1.5 min)
    local function UserSync()
        if ig.data.ArePlayersActive() then
            ig.sql.save.Users()
        end
        SetTimeout(conf.serversync, UserSync)
    end
    SetTimeout(conf.serversync, UserSync)
    
    -- Vehicle sync - less frequent (5 min)
    local function VehicleSync()
        if ig.data.ArePlayersActive() then
            ig.sql.save.Vehicles()
        end
        SetTimeout(conf.vehiclesync, VehicleSync)
    end
    SetTimeout(conf.vehiclesync, VehicleSync)
    
    -- Job sync - least frequent (10 min)
    local function JobSync()
        if ig.data.ArePlayersActive() then
            ig.sql.save.Jobs()
        end
        SetTimeout(conf.jobsync, JobSync)
    end
    SetTimeout(conf.jobsync, JobSync)
    
    -- Object sync - moderate frequency (5 min)
    local function ObjectSync()
        if ig.data.ArePlayersActive() then
            ig.sql.save.Objects()
        end
        SetTimeout(conf.objectsync, ObjectSync)
    end
    SetTimeout(conf.objectsync, ObjectSync)
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
    ig.items        = ig.json.Load('Items') or {}
    ig.drops        = ig.json.Load('Drops') or {}
    ig.active_drops = {}  -- always reset
    ig.picks        = ig.json.Load('Pickups') or {}
    ig.scenes       = ig.json.Load('Scenes') or {}
    ig.notes        = ig.json.Load('Notes') or {}
    ig.gsrs         = ig.json.Load('GSR') or {}
    ig.jobs         = ig.json.Load('Jobs') or {}
    ig.doors        = ig.json.Load('Doors') or {}
    ig.objects      = ig.json.Load('Objects') or {}
    ig.names        = ig.json.Load('Names') or {}

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
    -- These tables should never be modified at runtime
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
