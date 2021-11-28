-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
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
    c.debug_1('Loading Sequence Begin.')
    local num, loaded = 0, false
    local t = {
        [1] = 'DB: Characters marked as In-Active;',
        [2] = 'DB: Jobs have been Generated;',
        [3] = 'DB: Finding Job Accounts or Creating them;',
        [4] = 'DB: Job Accounts have been Generated;',
        [5] = 'DB: Job Objects Created and Added;',
        [6] = 'DB: Loading Data File - GSR;',
        [7] = 'DB: Loading Data File - Drops;',
        [8] = 'DB: Loading Data File - Pickups;',
        [9] = 'DB: Loading Data File - Notes;',
        [10] = 'DB: Loading Data File - Names;'
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
        --
        loaded = true
    end)

    while not loaded do
        Wait(250)
    end

    c.Loading = false
    c.debug_1('Loading Sequence Complete.')
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
    if type(c.pdex[tonumber(source)]) == 'table' then
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

-- ====================================================================================--
-- Vehicles - c.vdex = Object Table with xVehicle as referance obj, c.vehicle = function table

function c.data.AddVehicle(net, cb, ...)
    if not c.vehicle.Find(net) then
        c.vdex[net] = cb(...)
    end
end

--- Get the xVehicle Data/Table
---@param net integer "Network ID 16 bit integer"
function c.data.GetVehicle(net)
    return c.vdex[net] or false
end

--- Same as above.
---@param net integer "Network ID 16 bit integer"
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
function c.data.RemoveVehicle(net)
    c.vdex[net] = false
end

---@param plate string "Plate of vehicle."
function c.data.GetVehicleByPlate(plate)
    return c.vehicle.GetByPlate(plate)
end

---@param plate string "Plate of vehicle."
function c.GetVehicleByPlate(plate)
    return c.data.GetVehicleByPlate(plate)
end

-- ====================================================================================--
-- NPC's 

function c.data.AddNpc(net, cb, ...)
    if not c.npc.Find(net) then
        c.ndex[net] = cb(...)
    end
end

--- Get the xVehicle Data/Table
---@param net integer "Network ID 16 bit integer"
function c.data.GetNpc(net)
    return c.ndex[net] or false
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
    c.ndex[net] = false
end

-- ====================================================================================--
-- NPC's 

function c.data.AddObject(net, cb, ...)
    if not c.object.Find(net) then
        c.odex[net] = cb(...)
    end
end

--- Get the xVehicle Data/Table
---@param net integer "Network ID 16 bit integer"
function c.data.GetObject(net)
    return c.odex[net] or false
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
    c.odex[net] = false
end

-- ====================================================================================--
-- Jobs - c.jdex = Object table, c.jobs = table built from the DB, c.job = functions.

--- func desc
function c.data.CreateJobObjects()
    local jobs = c.job.GetJobs()
    for k, v in pairs(jobs) do
        if not c.jdex[k] then
            c.jdex[k] = c.class.CreateJob(v)
            ExecuteCommand(("add_principal job.%s events.%s"):format(k, k))
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
]]--
--
function c.GetEntityObject(t,n)
    return c.data.GetEntityObject(t,n)
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

function c.data.UpdatePacket(source, data)
    local src = source
    local xPlayer = c.data.GetPlayer(src)
    --
    -- Place a check prior to running the update.
    if data.Health then
        xPlayer.SetHealth(data.Health)
    end
    if data.Armour then
        xPlayer.SetArmour(data.Armour)
    end
    if data.Hunger then
        xPlayer.SetHunger(data.Hunger)
    end
    if data.Thirst then
        xPlayer.SetThirst(data.Thirst)
    end
    if data.Stress then
        xPlayer.SetStress(data.Stress)
    end
    if data.Modifiers then
        xPlayer.SetModifiers(data.Modifiers)
    end
    if data.Coords then
        xPlayer.SetCoords(data.Coords)
    end

    --
    -- Run Additional Functions post data update.
    c.state.UpdateStates(src)
end

--- Create xPlayer table and pass to client.
---@param source number
---@param Character_ID string
function c.data.LoadPlayer(source, Character_ID)
    local src = tonumber(source)
    local p = promise.new()
    -- Fuck Metatable inheritance.
    local xUser = c.class.CreateUser(src)
    local xCharacter = c.class.CreateCharacter(src, Character_ID)
    local xPlayer = c.table.Merge(xUser, xCharacter)
    -- No need to pass data to the client anymore.
    c.sql.char.SetActive(Character_ID, true, function()
        c.data.SetPlayer(src, xPlayer)
        c.inst.SetPlayer(source, xPlayer.GetInstance())
        p:resolve()
    end)
    -- Wait for the player to be loaded prior to sending the "ok" to load to the client.
    Citizen.Await(p)
    TriggerClientEvent('Client:Character:Loaded', src)
end

function c.data.ClientSync()
    local function Do()
        local xPlayers = c.data.GetPlayers()
        for source, xPlayer in pairs(xPlayers) do
            -- Incase its false
            if xPlayer then
                local src = tonumber(source)
                local data = TriggerClientCallback({
                    source = src,
                    eventName = 'DataPacket',
                    args = {}
                })
                c.data.UpdatePacket(source, data)
            end
        end
        SetTimeout(conf.clientsync, Do)
    end
    SetTimeout(conf.clientsync, Do)
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

--- Return the Players's state bag.
---@param id any "Typically a number or string"
function c.data.GetPlayerState(id)
    return Player(id).state
end

--- Return the Players's state bag.
---@param id any "Typically a number or string"
function c.GetPlayerState(id)
    return c.data.GetPlayerState(id)
end
