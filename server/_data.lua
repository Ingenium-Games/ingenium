-- ====================================================================================--
c.data = {} -- data table for funcitons.
c.pdex = {} -- player index = pdex (source numbers assigned by the server upon connection order)

-- ====================================================================================--

--- Used on startup prior to the server really running.
function c.data.Initilize()
    c.func.Debug_1("Loading Sequence Begin.")
    local num, loaded = 0, false
    local t = {
        [1] = "DB: Characters marked as In-Active;",
        [2] = "DB: Jobs have been Generated;",
        [3] = "DB: Finding Job Accounts or Creating them;",
        [4] = "DB: Job Accounts have been Generated;",
        [5] = "DB: Job Objects Created and Added;",
        [6] = "DB: Loading Data File - GSR;",
        [7] = "DB: Loading Data File - Drops;",
        [8] = "DB: Loading Data File - Pickups;",
        [9] = "DB: Loading Data File - Notes;",
        [10] = "DB: Loading Data File - Names;",
        [11] = "DB: Reset Cars to Parked;",
        [12] = "DB: "
    }
    --
    local function cb()
        num = num + 1
        c.func.Debug_1(t[num])
    end
    --
    MySQL.ready(function()
        -- Add other SQL commands required on start up.
        -- such as cleaning tables, requesting data, etc..
        -- [1]
        c.sql.ResetActiveCharacters(cb)
        -- [2]
        c.sql.jobs.Generate(cb)
        -- [3]
        c.sql.jobs.Setup(cb)
        -- [4]
        c.sql.jobs.Accounts(cb)
        -- [5] -- Not so much a SQL function, but dependant on it being conducted in order.
        c.data.CreateJobObjects()
        cb()
        -- [6] gunshot residue data table
        c.gsr.Load()
        cb()
        -- [7] dropped items data table
        c.drop.Load()
        cb()
        -- [8] pickups data table (not items script)
        c.pick.Load()
        cb()
        -- [9] notes data table (notepad script)
        c.note.Load()
        cb()
        -- [10] Load names for random names selection.
        c.name.Load()
        cb()

        -- [12]
        c.sql.veh.Reset(cb)
        --
        c.sql.obj.GetObjects()
        --
        loaded = true
    end)

    while not loaded do
        Wait(250)
    end

    c._loading = false
    c.func.Debug_1("Loading Sequence Complete.")
    c._running = true
end

-- ====================================================================================--

--- Adds player to the player index.
---@param source number "source [server_id]"
function c.data.AddPlayer(source)
    local num = tonumber(source)
    c.pdex[num] = false
end

--- Gets player from the player table.
---@param source number
function c.data.GetPlayer(source)
    if type(c.pdex[tonumber(source)]) == "table" then
        return c.pdex[tonumber(source)]
    else
        return false
    end
end

--- Same as above.
---@param source number
function c.GetPlayer(source)
    return c.data.GetPlayer(tonumber(source))
end

--- Same as above.
---@param source number
function c.GetPlayerFromId(source)
    return c.data.GetPlayer(tonumber(source))
end

--- Set the player id to the table.
---@param source number
---@param data table
function c.data.SetPlayer(source, data)
    c.pdex[tonumber(source)] = data
end

--- Set to false.
---@param source number
function c.data.RemovePlayer(source)
    c.pdex[tonumber(source)] = false
end

--- Get the player table
function c.data.GetPlayers()
    return c.pdex
end

--- Wrapper for the above.
function c.GetPlayers()
    return c.data.GetPlayers()
end

--- func desc
---@param character_id any
function c.data.GetOfflinePlayer(character_id)
    if character_id then
        local data = c.sql.char.Get(character_id)
        if data then
            local temp = c.class.OfflinePlayer(data)
            return temp
        end
    end
    return nil
end

--- Return corresponding player data from character_id
---@param id string "Character_ID"
function c.data.GetPlayerByIdentifier(id)
    for k, v in pairs(c.pdex) do
        if v then
            if v.GetCharacter_ID() == tostring(id) then
                return c.data.GetPlayer(k)
            end
        end
    end
    return nil
end

--- Wrapper for the above.
function c.GetPlayerFromIdentifier(id)
    return c.data.GetPlayerByIdentifier(id)
end

--- Return corresponding player data from character_id
---@param id string "Character_ID"
function c.data.GetPlayerIDByIdentifier(id)
    for k, v in pairs(c.pdex) do
        if v then
            if v.GetCharacter_ID() == id then
                return k
            end
        end
    end
    return nil
end

--- func desc
function c.data.ArePlayersActive()
    local ptbl = GetPlayers()
    if type(ptbl) == "table" and #ptbl >= 1 then
        return true
    end
    return false
end

-- ====================================================================================--
-- Vehicles - c.vdex = Object Table with xVehicle as referance obj, c.vehicle = function table

---@param net integer "Network ID 16 bit integer"
function c.data.FindVehicle(net)
    for k, v in pairs(c.vdex) do
        if v then
            if v.Net == net then
                return true, v, k
            end
        end
    end
    return false, false, false
end

---@param plate string "Plate of vehicle."
function c.data.FindVehicleFromPlate(plate)
    for k, v in pairs(c.vdex) do
        if (v and v.Plate == plate) then
            return true
        end
    end
    return false
end

---@param plate string "Plate of vehicle."
function c.data.GetVehicleByPlate(plate)
    for k, v in pairs(c.vdex) do
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
function c.data.AddVehicle(net, cb, ...)
    -- local aa, bb, cc = c.data.FindVehicle(net)
    -- if (not aa) then
        c.vdex[tonumber(net)] = cb(...)
    -- end
end

--- func desc
---@param net any
---@param cb any
function c.data.SetVehicle(net, cb, ...)
    c.vdex[tonumber(net)] = cb(...)
    return c.vdex[tonumber(net)]
end

--- Get the xVehicle Data/Table
---@param net integer "Network ID 16 bit integer or Plate (8 char string)"
function c.data.GetVehicle(arg)
    if c.vdex[tonumber(arg)] ~= false then
        return c.vdex[tonumber(arg)]
    else
        c.func.Debug_1("No Vehicle Found.")
        return false
    end
end

--- Same as above.
---@param net integer "Network ID 16 bit integer or Plate (8 char string)"
function c.GetVehicle(net)
    return c.data.GetVehicle(net)
end

--- Get all xVehicles
function c.data.GetVehicles()
    return c.vdex
end

--- Get all xVehicles
function c.GetVehicles()
    return c.data.GetVehicles()
end

-- Set to false for cleanup function inside _vehicles.lua
--- func desc
---@param arg any
function c.data.RemoveVehicle(arg)
    if c.vdex[tonumber(arg)] then
        c.vdex[tonumber(arg)] = false
    end
end

---@param plate string "Plate of vehicle."
function c.GetVehicleByPlate(plate)
    return c.data.GetVehicleByPlate(plate)
end

-- ====================================================================================--
-- NPC"s 

---@param net integer "Network ID 16 bit integer"
function c.data.FindNpc(arg)
    for k, v in pairs(c.ndex) do
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
function c.data.AddNpc(net, cb, ...)
    if not c.data.FindNpc(net) then
        c.ndex[tonumber(net)] = cb(...)
    end
end

--- Get the xVehicle Data/Table
---@param net integer "Network ID 16 bit integer"
function c.data.GetNpc(net)
    return c.ndex[tonumber(net)] or false
end

--- Same as above.
---@param net integer "Network ID 16 bit integer"
function c.GetNpc(net)
    return c.data.GetNpc(net)
end

--- Get all xVehicles
function c.data.GetNpcs()
    return c.ndex
end

--- Get all xVehicles
function c.GetNpcs()
    return c.data.GetNpcs()
end

-- Set to false for cleanup function inside _vehicles.lua
--- func desc
---@param net any
function c.data.RemoveNpc(net)
    c.ndex[tonumber(net)] = false
end

-- ====================================================================================--
-- 

---@param net integer "Network ID 16 bit integer"
function c.data.FindObject(net)
    for k, v in pairs(c.odex) do
        if v then
            if k == net and type(v) == "table" then
                return true, v, k
            end
        end
    end
    return false, false, false
end

---@param net integer "Network ID 16 bit integer"
function c.data.FindObjectFromUUID(uuid)
    for k, v in pairs(c.odex) do
        if v and (v.UUID == uuid) then
            return true, v, k
        end
    end
    return false, false, false
end

---@param net integer "Network ID 16 bit integer"
function c.data.GetObjectFromUUID(uuid)
    for k, v in pairs(c.odex) do
        if v and (v.UUID == uuid) then
            return v
        end
    end
    return false
end

--- func desc
---@param net any
---@param cb any
function c.data.AddObject(net, cb, ...)
    if not c.data.FindObject(net) then
        c.odex[tostring(net)] = cb(...)
    end
end

--- Get the xVehicle Data/Table
---@param net integer "Network ID 16 bit integer"
function c.data.GetObject(net)
    return c.odex[tostring(net)] or false
end

--- Same as above.
---@param net integer "Network ID 16 bit integer"
function c.GetObject(net)
    return c.data.GetObject(net)
end

--- Get all xVehicles
function c.data.GetObjects()
    return c.odex
end

--- Get all xVehicles
function c.GetObjects()
    return c.data.GetObjects()
end

-- Set to false for cleanup function inside _vehicles.lua
--- func desc
---@param net any
function c.data.RemoveObject(uuid)
    c.odex[tostring(net)] = false
end

-- ====================================================================================--
-- Jobs - c.jdex = Object table, c.jobs = table built from the DB, c.job = functions.

--- func desc
function c.data.CreateJobObjects()
    local jobs = c.job.GetJobs()
    for k, v in pairs(jobs) do
        if not c.jdex[k] then
            c.jdex[k] = c.class.Job(v)
        end
    end
    c.json.Write(conf.file.jobs, c.jobs)
end

--- func desc
function c.data.GetJobs()
    return c.jdex
end

--- func desc
---@param str any
function c.data.GetJob(str)
    return c.jdex[str]
end

--- func desc
---@param str any
function c.GetJob(str)
    return c.data.GetJob(str)
end

-- ====================================================================================--

--- func desc
---@param str any
function c.data.Save(str)

end

-- Server to Datatable routine.
function c.data.RetrievePackets()
    local plys = c.data.GetPlayers()
    for k, v in pairs(plys) do
        if v then
            local data = TriggerClientCallback({
                source = k,
                eventName = "DataPacket",
                args = {}
            })
            if data then
                local xPlayer = c.data.GetPlayer(k)
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
function c.data.CharacterValues()
    local function Do()
        c.data.RetrievePackets()
        SetTimeout(conf.charactersync, Do)
    end
    SetTimeout(conf.charactersync, Do)
end

-- Server to DB routine.
function c.data.ServerSync()
    local function Do()
        if c.data.ArePlayersActive() then
            --
            c.sql.save.Users()
            print("   ^7[^5SQL^7]: Users")
            Citizen.Wait(conf.sec * 5)
            --
            c.sql.save.Vehicles()
            print("   ^7[^5SQL^7]: Vehicles")
            Citizen.Wait(conf.sec * 5)
            --
            c.sql.save.Jobs()
            print("   ^7[^5SQL^7]: Jobs")
            Citizen.Wait(conf.sec * 5)
            --
            c.sql.save.Objects()
            print("   ^7[^5SQL^7]: Objects")
            Citizen.Wait(conf.sec * 5)
            --
            print("   ^7[^3Server Sync Completed^7]")
        end
        SetTimeout(conf.serversync, Do)
    end
    SetTimeout(conf.serversync, Do)
end

-- Server to DB routine.
function c.data.ReviveSync()
    local function Do()
        local result = c.sql.char.ReviveDeadCharacters()
        if result then
            c.func.Debug_2("Revived Characters")
        end
        SetTimeout(conf.revivesync, Do)
    end
    SetTimeout(conf.revivesync, Do)
end

-- ====================================================================================--

--- Create xPlayer table and pass to client.
---@param source number
---@param Character_ID string
function c.data.LoadPlayer(source, Character_ID)
    local src = tonumber(source)
    local p = promise.new()
    local xPlayer = c.class.Player(src, Character_ID)
    -- No need to pass data to the client anymore.
    c.sql.char.SetActive(Character_ID, true, function()
        c.data.SetPlayer(src, xPlayer)
        p:resolve()
    end)
    -- Wait for the player to be loaded prior to sending the "ok" to load to the client.
    Citizen.Await(p)
    TriggerClientEvent("Client:Character:Loaded", src)
end

-- ====================================================================================--

--- Return the Entity"s state bag.
---@param net any "Network ID 16 bit integer"
function c.data.GetEntityStateBag(net)
    return Entity(NetworkGetEntityFromNetworkId(net)).state
end

--- Return the Entity"s state bag.
---@param net any "Network ID 16 bit integer"
function c.GetEntityState(net)
    return c.data.GetEntityStateBag(net)
end

--- Return the Players"s state bag.
---@param id any "Typically a number or string"
function c.data.GetPlayerState(id)
    return Player(id).state
end

--- Return the Players"s state bag.
---@param id any "Typically a number or string"
function c.GetPlayerState(id)
    return c.data.GetPlayerState(id)
end
