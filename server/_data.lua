-- ====================================================================================--
c.data = {} -- data table for funcitons.
c.pdex = {} -- player index = pdex (source numbers assigned by the server upon connection order)
--[[
NOTES.
    -
    -
    -
]] --

-- ====================================================================================--

--- Used on startup prior to the server really running.
function c.data.Initilize()
    c.debug_1("Loading Sequence Begin.")
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
        [11] = "DB: Loading Data File - Scenes;";
        [12] = "DB: Regenerating Vehicles - [^5LOADED^0]";
    }
    --
    local function cb()
        num = num + 1
        c.debug_1(t[num])
    end
    --
    MySQL.ready(function()
        -- Add other SQL commands required on start up.
        -- such as cleaning tables, requesting data, etc..
        -- [1]
        c.sql.ResetActiveCharacters(cb)
        -- [2]
        c.sql.jobs.GetAll(cb)
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
        -- [11] Load names for random names selection.
        c.scene.Load()
        cb()
        -- [12]
        c.sql.veh.Regenerate()
        cb()

        --
        loaded = true
    end)

    while not loaded do
        Wait(250)
    end

    c.Loading = false
    c.debug_1("Loading Sequence Complete.")
    c.Running = true
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

--- Return corresponding player data from character_id
---@param id string "Character_ID"
function c.data.GetPlayerByIdentifier(id)
    for k, v in pairs(c.pdex) do
        if v then
            if v.Character_ID == id then
                return c.GetPlayer(k)
            end
        end
    end
    return nil
end

--- Wrapper for the above.
function c.GetPlayerFromIdentifier(id)
    return c.data.GetPlayerByIdentifier(id)
end

function c.data.ArePlayersActive()
    local ptbl = GetPlayers()    
    if type(ptbl) == "table" and #ptbl > 1 then
        return true                
    end
    return false
end
-- ====================================================================================--
-- Vehicles - c.vdex = Object Table with xVehicle as referance obj, c.vehicle = function table

---@param net integer "Network ID 16 bit integer or Plate (8 char string)"
function c.data.FindVehicle(arg)
    if type(arg) == "string" and arg:len() == 8 then
        for k, v in pairs(c.pvdex) do
            if k == arg then
                return true, v, k
            end
        end
        return false, false, false
    else
        for k, v in ipairs(c.vdex) do
            if k == arg and type(v) == "table" then
                return true, v, k
            end
        end
        return false, false, false
    end
end

---@param plate string "Plate of vehicle."
function c.data.GetVehicleByPlate(plate)
    for k, v in pairs(c.pvdex) do
        if k == plate then
            return v
        end
    end
    for k, v in pairs(c.vdex) do
        if v then
            if v.Plate == plate then
                return v
            end
        end
    end
    return false
end

function c.data.AddVehicle(net, cb, ...)
    if not c.data.FindVehicle(net) then
        c.vdex[tonumber(net)] = cb(...)
    end
end

function c.data.AddPlayerVehicle(arg, cb, ...)
    local arg = tostring(arg)
    if not c.data.FindVehicle(arg) then
        c.pvdex[arg] = cb(...)
    end
end

--- Get the xVehicle Data/Table
---@param net integer "Network ID 16 bit integer or Plate (8 char string)"
function c.data.GetVehicle(arg)
    local found, data = c.data.FindVehicle(arg)
    return data
end

--- Same as above.
---@param net integer "Network ID 16 bit integer or Plate (8 char string)"
function c.GetVehicle(net)
    return c.data.GetVehicle(net)
end

--- Get all xVehicles
function c.data.GetVehicles()
    return c.pvdex
end

--- Get all xVehicles
function c.GetVehicles()
    return c.data.GetVehicles()
end

-- Set to false for cleanup function inside _vehicles.lua
function c.data.RemoveVehicle(arg)
    if c.vdex[tonumber(arg)] then
        c.vdex[tonumber(arg)] = false
    else
        c.pvdex[tonumber(arg)] = false
    end
end

---@param plate string "Plate of vehicle."
function c.GetVehicleByPlate(plate)
    return c.data.GetVehicleByPlate(plate)
end

-- ====================================================================================--
-- NPC"s 

function c.data.AddNpc(net, cb, ...)
    if not c.npc.Find(net) then
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
function c.data.RemoveNpc(net)
    c.ndex[tonumber(net)] = false
end

-- ====================================================================================--
-- NPC"s 

function c.data.AddObject(net, cb, ...)
    if not c.object.Find(net) then
        c.odex[tonumber(net)] = cb(...)
    end
end

--- Get the xVehicle Data/Table
---@param net integer "Network ID 16 bit integer"
function c.data.GetObject(net)
    return c.odex[tonumber(net)] or false
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
function c.data.RemoveObject(net)
    c.odex[tonumber(net)] = false
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

function c.data.GetJobs()
    return c.jdex
end

function c.data.GetJob(str)
    return c.jdex[str]
end

function c.GetJob(str)
    return c.data.GetJob(str)
end

-- ====================================================================================--
--[[ THis one was to be a swiss army knife, but may need more work...
function c.data.GetEntityObject(type, net)
    --
    -- Object
    if type == 3 then
        return c.data.GetObject(net)
    --
    -- Vehicle
    elseif type == 2 then
        return c.data.GetVehicle(net)
    --
    -- Ped
    elseif type == 1 then
        local ent = NetworkGetEntityFromNetworkId(net)
        local owner = NetworkGetEntityOwner(ent)
        if IsPedAPlayer(ent) then
            -- should be the player of the ped that it is???
            if owner >= 1 then
                return c.data.GetPlayer(owner)
            else
                return false
            end
        else
            return c.data.GetNpc(net)
        end
    else
        -- no other types // fin    
    end
end
]] --
--
function c.GetEntityObject(t, n)
    return c.data.GetEntityObject(t, n)
end
--
function c.data.Save(str)
    print("   ^7[^5Saved^7]:  ==    ", str)
end

-- Server to DB routine.
function c.data.ServerSync()
    local function Do()
        c.sql.save.Users()
        Citizen.Wait(conf.sec * 5)
        c.sql.save.Vehicles()
        Citizen.Wait(conf.sec * 5)
        c.sql.save.Jobs()
        Citizen.Wait(conf.sec * 5)
        c.data.Save("Users, Vehicles, Jobs, ")
        SetTimeout(conf.serversync, Do)
    end
    SetTimeout(conf.serversync, Do)
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
function c.data.GetEntityState(net)
    return Entity(NetworkGetEntityFromNetworkId(net)).state
end

--- Return the Entity"s state bag.
---@param net any "Network ID 16 bit integer"
function c.GetEntityState(net)
    return c.data.GetEntityState(net)
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
