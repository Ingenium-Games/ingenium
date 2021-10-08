-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.data = {} -- data table for funcitons.
c.pdex = {} -- player index = pdex (source numbers assigned by the server upon connection order)
--[[
NOTES.
    -
    -
    -
]]--

math.randomseed(c.Seed)
-- ====================================================================================--


function c.data.LoadFiles()
    c.gsr.Load()
    c.gsr.CleanUp()

    c.drop.Load()
    c.drop.CleanUp()

    c.pick.Load()
    c.pick.CleanUp()

    c.note.Load()
    c.note.CleanUp()    
end


--- Used on startup prior to the server really running.
function c.data.Initilize()
    c.debug('Loading Sequence Begin.')
    local num, loaded = 0, false
    local t = {
        [1] = 'DB: Characters marked as In-Active;',
        [2] = 'DB: Jobs have been Generated;',
        [3] = 'DB: Finding Job Accounts or Creating them;',
        [4] = 'DB: Job Accounts have been Generated;',
        [5] = 'DB: Job Objects Created and Added;',
        [6] = 'DB: Loading Data Files - Drops, Pickups, Notes, GSR;'
    }
    --
    local function cb()
        num = num + 1
        c.debug(t[num])
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
        --
        c.data.LoadFiles()
        cb()
        --
        loaded = true
    end)

    while not loaded do
        Wait(250)
    end
    
    c.Loading = false
    c.debug('Loading Sequence Complete.')
    c.Running = true

    -- Testing Table builds from SQL builds.
    -- print(c.table.Dump(c.jobs))
    
    -- this is to test the table locker function.
    conf.lock = c.rng.chars(10)  
    SetTimeout(c.min, function()
        print(conf.lock)
        c.debug("locking tables...")
    end)
    --
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
    for k,v in pairs(c.pdex) do
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
    
function c.data.AddVehicle(net, plate, stolen)
    if not c.vehicle.Find(net) then
        if plate then
            c.vdex[net] = c.class.OwnedVehicle(net, plate)
        else
            c.vdex[net] = c.class.UnownedVehicle(net, stolen)
        end
    end
end

--- Get the xVehicle Data/Table
---@param net integer "Network ID 16 bit integer"
function c.data.GetVehicle(net)
    return c.vdex[net]
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

---@param plate string "Plate of vehicle."
function c.data.GetVehicleByPlate(plate)
   return c.vehicle.GetByPlate(plate)
end

---@param plate string "Plate of vehicle."
function c.GetVehicleByPlate(plate)
    return c.data.GetVehicleByPlate(plate)
end

-- ====================================================================================--
-- Jobs - c.jdex = Object table, c.jobs = table built from the DB, c.job = functions.

 --- func desc
function c.data.CreateJobObjects()
    local jobs = c.job.GetJobs()
    for k,v in pairs(jobs) do
        if not c.jdex[k] then
            c.jdex[k] = c.class.CreateJob(v)
        end
    end
    c.json.Write(conf.file.jobs, c.jobs)
    -- Lock the Jobs after DV Pull.
    setmetatable(c.jobs,c.meta)
    setmetatable(c.jdex,c.meta)
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