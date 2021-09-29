-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]] --

math.randomseed(c.Seed)
-- ====================================================================================--
--  Get Character Info for the NUI to allow character selection.
RegisterNetEvent('Server:Character:Request:List')
AddEventHandler('Server:Character:Request:List', function(req, Primary_ID)
    local src = tonumber(req) or source
    local Characters = c.sql.char.GetAll(Primary_ID)
    local Command = "OnJoin"
    -- Send the data table to the client that requested it...
    TriggerClientEvent('Client:Character:Open', src, Command, Characters)
    -- Place the user in their own instance until the user has joined and loaded.
    c.inst.SetPlayer(src, c.inst.New(), true)
end)

RegisterNetEvent('Server:Character:Request:Join')
AddEventHandler('Server:Character:Request:Join', function(Character_ID)
    local src = tonumber(source)
    -- If the User selected the NEW button on the NUI, the Character_ID will be listed as NEW, if this is the case, trigger the registration NUI?
    if (Character_ID == 'New') then
        local message = "OnNew"
        TriggerClientEvent('Client:Character:Open', src, message)
    elseif Character_ID ~= nil then
        local Coords = c.sql.char.GetCoords(Character_ID)
        c.data.LoadPlayer(src, Character_ID)
        TriggerClientEvent('Client:Character:ReSpawn', src, Character_ID, Coords)
    elseif Character_ID == nil then
        local message = "OnNew"
        TriggerClientEvent('Client:Character:Open', src, message)
    end
end)

RegisterNetEvent('Server:Character:Request:Delete')
AddEventHandler('Server:Character:Request:Delete', function(Character_ID)
    local src = tonumber(source)
    local prim = c.identifier(src)
    c.sql.char.Delete(Character_ID, function()
        TriggerEvent('Server:Character:Request:List', src, prim)
    end)
end)


-- Need to move this and clean it the fuck up, its gross atm.
RegisterNetEvent('Server:Character:Request:Create')
AddEventHandler('Server:Character:Request:Create', function(first_name, last_name, height, date)
    local src = tonumber(source)
    local char = c.sql.gen.CharacterID()
    local city = c.sql.gen.CityID()
    local phone = c.sql.gen.PhoneNumber()
    local banknum = c.sql.gen.AccountNumber()
    local prim = c.identifier(src)
    local data = {
        Primary_ID = prim, -- Owner
        Character_ID = char, -- Unique ID
        First_Name = first_name,
        Last_Name = last_name,
        Height = height,
        Birth_Date = date,
        City_ID = city,
        Phone = phone,
        Coords = json.encode(conf.spawn),
        Job = json.encode(conf.default.job),
        Accounts = json.encode(conf.default.accounts),
        Modifiers = json.encode(conf.default.modifiers),
    }
    c.sql.char.Add(data, function()
        -- CHain other required actions upon the initial data being added, like other tables that use forigen keys etc.
        c.sql.bank.AddAccount(char, banknum)
        
    end)
    c.data.LoadPlayer(src, char)
    TriggerClientEvent('Client:Character:FirstSpawn', src)
    --[[
            ADD YOUR CHARACTER CREATION EVENT BELOW
    ]]--
    
    TriggerClientEvent('creator:OpenCreator', src)
    
    --[[
            ADD YOUR CHARACTER CREATION EVENT ABOVE
    ]]--
    Wait(500)
    c.inst.SetPlayer(src, c.inst.New())
end)


-- Triggered after character has been loaded from db and informaiton is passed to client
RegisterNetEvent("Server:Character:Loaded")
AddEventHandler("Server:Character:Loaded", function()
    local src = source
    local ped = GetPlayerPed(src)
    local xPlayer = c.data.GetPlayer(src)

    -- CPED_CONFIG_FLAG_DontInfluenceWantedLevel = 42,
    -- CPED_CONFIG_FLAG_CanPerformArrest = 155, CPED_CONFIG_FLAG_CanPerformUncuff = 156, CPED_CONFIG_FLAG_CanBeArrested = 157
    -- CPED_CONFIG_FLAG_IgnoreBeingOnFire = 430,
    -- CPED_CONFIG_FLAG_DisableHomingMissileLockon = 434,

    local nums = {42,155,156,157,430,434}
    for _,v in pairs(nums) do
        SetPedConfigFlag(ped, v, false)
    end
end)

-- Triggered by the client after it has recieved its character data.
RegisterNetEvent("Server:Character:Ready")
AddEventHandler("Server:Character:Ready", function()
    local src = source
    local xPlayer = c.data.GetPlayer(src)
    -- Remove from current ACL Job Group
    ExecuteCommand(('remove_principal identifier.%s job.%s'):format(xPlayer.GetLicense_ID(), xPlayer.GetJob().Name))
    --
    xPlayer.SetJob(xPlayer.GetJob())
    Wait(250)
    --
    TriggerEvent('Server:Character:SetJob', xPlayer.ID, xPlayer.GetJob())
    TriggerClientEvent('Client:Character:SetJob', xPlayer.ID, xPlayer.GetJob())
    --
end)

-- Use this to remove any things connected to Characters like police blips etc.
RegisterNetEvent("Server:Character:Switch")
AddEventHandler("Server:Character:Switch", function(req)
    local src = req or source
    local xPlayer = c.data.GetPlayer(src)
    -- Remove Player Identifier from job as entity if no longer existing.
    ExecuteCommand(('remove_principal identifier.%s job.%s'):format(xPlayer.License_ID, xPlayer.GetJob().Name))
    --

end)

-- Server Death Handler - if was killed by a player or not.
RegisterNetEvent("Server:Character:Death")
AddEventHandler("Server:Character:Death", function(data)
    local src = source
    if (data.PlayerKill == true) then
        c.discord(conf.deathlog)
    else
        c.discord(conf.deathlog)
    end
end)

--@ req = server_id or source
--@ t = {'name'='police','grade'=0}
RegisterNetEvent("Server:Character:SetJob")
AddEventHandler("Server:Character:SetJob", function(req, data)
    local src = req or source
    local xPlayer = c.data.GetPlayer(src)
    -- Add New Job command permissions for ACL system
    ExecuteCommand(('add_principal identifier.%s job.%s'):format(xPlayer.License_ID, xPlayer.GetJob().Name))
end)

-- Default player to instance listed in conf.defaultinstance
RegisterNetEvent('Server:Instance:Player:Default')
AddEventHandler('Server:Instance:Player:Default', function(req)
    local src = req or source
    c.inst.SetPlayerDefault(src)
end)

-- ====================================================================================--
-- Bank Events for Transactions

RegisterNetEvent("Server:Bank:Deposit")
AddEventHandler("Server:Bank:Deposit", function(data, req)
    local src = req or source
    local amount = data
    local xPlayer = c.data.GetPlayer(src)
    --
    xPlayer.RemoveCash(amount)
    xPlayer.AddBank(amount)
    TriggerClientEvent("Client:Notify", xPlayer.ID, "Diposited $"..amount, "warn")
end)

RegisterNetEvent("Server:Bank:Withdraw")
AddEventHandler("Server:Bank:Withdraw", function(data, req)
    local src = req or source
    local amount = data
    local xPlayer = c.data.GetPlayer(src)
    --
    xPlayer.RemoveBank(amount)
    xPlayer.AddCash(amount)
    TriggerClientEvent("Client:Notify", xPlayer.ID, "Withdrew $"..amount, "warn")
end)

RegisterNetEvent("Server:Bank:Transfer")
AddEventHandler("Server:Bank:Transfer", function(data, req, id)
    local src = req or source
    local too = id
    local amount = data
    local xPlayer = c.data.GetPlayer(src)
    local tPlayer = c.data.GetPlayer(too)
    --
    xPlayer.RemoveBank(amount)
    tPlayer.AddBank(amount)
    TriggerClientEvent("Client:Notify", xPlayer.ID, "Sent $"..amount.." to "..tPlayer.Full_Name, "warn")
    TriggerClientEvent("Client:Notify", tPlayer.ID, "Recieved $"..amount.." from "..xPlayer.Full_Name, "warn")
end)

RegisterNetEvent("Server:Bank:Remove")
AddEventHandler("Server:Bank:Remove", function(data, req)
    local src = req or source
    local amount = data
    local xPlayer = c.data.GetPlayer(src)
    --
    xPlayer.RemoveBank(amount)
    TriggerClientEvent("Client:Notify", xPlayer.ID, "Payed $"..amount, "warn")
end)

RegisterNetEvent("Server:Bank:Add")
AddEventHandler("Server:Bank:Add", function(data, req)
    local src = req or source
    local amount = data
    local xPlayer = c.data.GetPlayer(src)
    --
    xPlayer.AddBank(amount)
    TriggerClientEvent("Client:Notify", xPlayer.ID, "$"..amount.." was added to your account.", "warn")
end)

RegisterNetEvent("Server:EnteringVehicle")
AddEventHandler("Server:EnteringVehicle", function(vehicle, seat, name, netId)
    local found = c.vehicle.Find(netId)
    if not found then
        local xVehicle = c.class.UnownedVehicle(netId)
        c.vehicle.Add(netId, xVehicle)
    end
end)

RegisterNetEvent("Server:EnteredVehicle")
AddEventHandler("Server:EnteredVehicle", function(vehicle, seat, name, netId)

end)

RegisterNetEvent("Server:LeftVehicle")
AddEventHandler("Server:LeftVehicle", function(vehicle, seat, name, netId)

end)

RegisterNetEvent("Server:EnteringVehicle:Aborted")
AddEventHandler("Server:EnteringVehicle:Aborted", function()
    -- before canceling event

    --
    CancelEvent()
end)

RegisterNetEvent("AssignVehicleData")
AddEventHandler("AssignVehicleData", function(net, plate, stolen)
    local src = source
    if plate then
        c.vehicle.Add(net, c.class.OwnedVehicle(net, plate))
    else
        c.vehicle.Add(net, c.class.UnownedVehicle(net, stolen))
    end
end)
