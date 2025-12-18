-- ====================================================================================--
ig.data = {} -- data table for funcitons.
ig.pdex = {} -- player index = pdex (source numbers assigned by the server upon connection order)
-- ====================================================================================--

--- Used on startup prior to the server really running.
function ig.data.Initilize()
    ig.funig.Debug_1("Loading Sequence Begin.")
    local num, loaded = 0, false
    local t = {
        [1] = "DB: Characters marked as In-Active;",
        [2] = "DB: Jobs have been Generated;",
        [3] = "DB: Finding Job Accounts or Creating them;",
        [4] = "DB: Job Accounts have been Generated;",
        [5] = "DB: Job Objects Created and Added;",
        [6] = "DB: Loading JSON Data Files;",
        [7] = "DB: Loading Data File - GSR;",
        [8] = "DB: Loading Data File - Drops;",
        [9] = "DB: Loading Data File - Pickups;",
        [10] = "DB: Loading Data File - Notes;",
        [11] = "DB: Loading Data File - Names;",
        [12] = "DB: Reset Cars to Parked;",
        [13] = "DB: "
    }
    --
    local function cb()
        num = num + 1
        ig.funig.Debug_1(t[num])
    end
    --
    MySQL.ready(function()
        -- Add other SQL commands required on start up.
        -- such as cleaning tables, requesting data, etig..
        -- [1]
        ig.sql.ResetActiveCharacters(cb)
        -- [2]
        ig.sql.jobs.Generate(cb)
        -- [3]
        ig.sql.jobs.Setup(cb)
        -- [4]
        ig.sql.jobs.Accounts(cb)
        -- [5] -- Not so much a SQL function, but dependant on it being conducted in order.
        ig.data.CreateJobObjects()
        cb()
        -- [5.5] -- Load JSON data files synchronously before individual loaders
        ig.data.LoadJSONData(cb)
        -- [6] gunshot residue data table
        ig.gsr.Load()
        cb()
        -- [7] dropped items data table
        ig.drop.Load()
        cb()
        -- [7.5] Restore physical drops from persistence
        ig.data.RestoreDrops()
        -- [8] pickups data table (not items script)
        ig.pick.Load()
        cb()
        -- [9] notes data table (notepad script)
        ig.note.Load()
        cb()
        -- [10] Load names for random names selection.
        ig.name.Load()
        cb()

        -- [12]
        ig.sql.veh.Reset(cb)
        --
        ig.sql.obj.GetObjects()
        --
        loaded = true
    end)

    while not loaded do
        Wait(250)
    end

    ig._loading = false
    ig.funig.Debug_1("Loading Sequence Complete.")
    ig._running = true
end

-- ====================================================================================--

--- Adds player to the player index.
---@param source number "source [server_id]"
function ig.data.AddPlayer(source)
    local num = tonumber(source)
    ig.pdex[num] = false
end

--- Gets player from the player table.
---@param source number
function ig.data.GetPlayer(source)
    if type(ig.pdex[tonumber(source)]) == "table" then
        return ig.pdex[tonumber(source)]
    else
        return false
    end
end

--- Same as above.
---@param source number
function ig.GetPlayer(source)
    return ig.data.GetPlayer(tonumber(source))
end

--- Same as above.
---@param source number
function ig.GetPlayerFromId(source)
    return ig.data.GetPlayer(tonumber(source))
end

--- Set the player id to the table.
---@param source number
---@param data table
function ig.data.SetPlayer(source, data)
    ig.pdex[tonumber(source)] = data
end

--- Set to nil for garbage collection.
---@param source number
function ig.data.RemovePlayer(source)
    ig.pdex[tonumber(source)] = nil
end

--- Get the player table
function ig.data.GetPlayers()
    return ig.pdex
end

--- Wrapper for the above.
function ig.GetPlayers()
    return ig.data.GetPlayers()
end

--- func desc
---@param character_id any
function ig.data.GetOfflinePlayer(character_id)
    if character_id then
        local data = ig.sql.char.Get(character_id)
        if data then
            local temp = ig.class.OfflinePlayer(data)
            return temp
        end
    end
    return nil
end

--- Return corresponding player data from character_id
---@param id string "Character_ID"
function ig.data.GetPlayerByIdentifier(id)
    for k, v in pairs(ig.pdex) do
        if v then
            if v.GetCharacter_ID() == tostring(id) then
                return ig.data.GetPlayer(k)
            end
        end
    end
    return nil
end

--- Wrapper for the above.
function ig.GetPlayerFromIdentifier(id)
    return ig.data.GetPlayerByIdentifier(id)
end

--- Return corresponding player data from character_id
---@param id string "Character_ID"
function ig.data.GetPlayerIDByIdentifier(id)
    for k, v in pairs(ig.pdex) do
        if v then
            if v.GetCharacter_ID() == id then
                return k
            end
        end
    end
    return nil
end

--- func desc
function ig.data.ArePlayersActive()
    local ptbl = GetPlayers()
    if type(ptbl) == "table" and #ptbl >= 1 then
        return true
    end
    return false
end

-- ====================================================================================--
-- Vehicles - ig.vdex = Object Table with xVehicle as referance obj, ig.vehicle = function table

---@param net integer "Network ID 16 bit integer"
function ig.data.FindVehicle(net)
    for k, v in pairs(ig.vdex) do
        if v then
            if v.Net == net then
                return true, v, k
            end
        end
    end
    return false, false, false
end

---@param plate string "Plate of vehicle."
function ig.data.FindVehicleFromPlate(plate)
    for k, v in pairs(ig.vdex) do
        if (v and v.Plate == plate) then
            return true
        end
    end
    return false
end

---@param plate string "Plate of vehicle."
function ig.data.GetVehicleByPlate(plate)
    for k, v in pairs(ig.vdex) do
        if v then
            if v.Plate == plate then
                return v
            end
        end
    end
    return false
end

--- func desc
---@param net any
---@param cb any
function ig.data.AddVehicle(net, cb, ...)
    -- local aa, bb, cc = ig.data.FindVehicle(net)
    -- if (not aa) then
        ig.vdex[tonumber(net)] = cb(...)
    -- end
end

--- func desc
---@param net any
---@param cb any
function ig.data.SetVehicle(net, cb, ...)
    ig.vdex[tonumber(net)] = cb(...)
    return ig.vdex[tonumber(net)]
end

--- Get the xVehicle Data/Table
---@param net integer "Network ID 16 bit integer or Plate (8 char string)"
function ig.data.GetVehicle(arg)
    if ig.vdex[tonumber(arg)] ~= false then
        return ig.vdex[tonumber(arg)]
    else
        ig.funig.Debug_1("No Vehicle Found.")
        return false
    end
end

--- Same as above.
---@param net integer "Network ID 16 bit integer or Plate (8 char string)"
function ig.GetVehicle(net)
    return ig.data.GetVehicle(net)
end

--- Get all xVehicles
function ig.data.GetVehicles()
    return ig.vdex
end

--- Get all xVehicles
function ig.GetVehicles()
    return ig.data.GetVehicles()
end

-- Set to nil for garbage collection
--- func desc
---@param arg any
function ig.data.RemoveVehicle(arg)
    if ig.vdex[tonumber(arg)] then
        ig.vdex[tonumber(arg)] = nil
    end
end

---@param plate string "Plate of vehicle."
function ig.GetVehicleByPlate(plate)
    return ig.data.GetVehicleByPlate(plate)
end

-- ====================================================================================--
-- NPC"s 

---@param net integer "Network ID 16 bit integer"
function ig.data.FindNpc(arg)
    for k, v in pairs(ig.ndex) do
        if v then
            if k == arg and type(v) == "table" then
                return true, v, k
            end
        end
    end
    return false, false, false
end

--- func desc
---@param net any
---@param cb any
function ig.data.AddNpc(net, cb, ...)
    if not ig.data.FindNpc(net) then
        ig.ndex[tonumber(net)] = cb(...)
    end
end

--- Get the xVehicle Data/Table
---@param net integer "Network ID 16 bit integer"
function ig.data.GetNpc(net)
    return ig.ndex[tonumber(net)] or false
end

--- Same as above.
---@param net integer "Network ID 16 bit integer"
function ig.GetNpc(net)
    return ig.data.GetNpc(net)
end

--- Get all xVehicles
function ig.data.GetNpcs()
    return ig.ndex
end

--- Get all xVehicles
function ig.GetNpcs()
    return ig.data.GetNpcs()
end

-- Set to nil for garbage collection
--- func desc
---@param net any
function ig.data.RemoveNpc(net)
    ig.ndex[tonumber(net)] = nil
end

-- ====================================================================================--
-- 

---@param net integer "Network ID 16 bit integer"
function ig.data.FindObject(net)
    for k, v in pairs(ig.odex) do
        if v then
            if k == net and type(v) == "table" then
                return true, v, k
            end
        end
    end
    return false, false, false
end

---@param net integer "Network ID 16 bit integer"
function ig.data.FindObjectFromUUID(uuid)
    for k, v in pairs(ig.odex) do
        if v and (v.UUID == uuid) then
            return true, v, k
        end
    end
    return false, false, false
end

---@param net integer "Network ID 16 bit integer"
function ig.data.GetObjectFromUUID(uuid)
    for k, v in pairs(ig.odex) do
        if v and (v.UUID == uuid) then
            return v
        end
    end
    return false
end

--- func desc
---@param net any
---@param cb any
function ig.data.AddObject(net, cb, ...)
    if not ig.data.FindObject(net) then
        ig.odex[tostring(net)] = cb(...)
    end
end

--- Get the xVehicle Data/Table
---@param net integer "Network ID 16 bit integer"
function ig.data.GetObject(net)
    return ig.odex[tostring(net)] or false
end

--- Same as above.
---@param net integer "Network ID 16 bit integer"
function ig.GetObject(net)
    return ig.data.GetObject(net)
end

--- Get all xVehicles
function ig.data.GetObjects()
    return ig.odex
end

--- Get all xVehicles
function ig.GetObjects()
    return ig.data.GetObjects()
end

-- Set to nil for garbage collection
--- func desc
---@param uuid any
function ig.data.RemoveObject(uuid)
    ig.odex[tostring(uuid)] = nil
end

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
            ig.funig.Debug_2("Revived Characters")
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
