-- ====================================================================================--


-- ====================================================================================--
--  Get Character Info for the NUI to allow character selection.
-- [C+S]
RegisterNetEvent("Server:Character:List")
AddEventHandler("Server:Character:List", function(req, Primary_ID)
    local src = tonumber(req) or source
    local p = promise.new()
    local Slots = c.sql.user.GetSlots(Primary_ID)
    p:resolve()
    Citizen.Await(p)
    local p = promise.new()
    local Characters = c.sql.char.GetAllPermited(Primary_ID, Slots)
    p:resolve()
    Citizen.Await(p)
    -- Send the data table to the client that requested it...
    TriggerClientEvent("Client:Core:UI", src, "Joining", {["Characters"] = Characters, ["Slots"] = Slots})
    -- Place the user in their own instance until the user has joined and loaded.
    c.inst.SetPlayer(src)
end)

-- [C]
RegisterNetEvent("Server:Character:Join")
AddEventHandler("Server:Character:Join", function(Character_ID)
    local src = tonumber(source)
    -- If the User selected the NEW button on the NUI, the Character_ID will be listed as NEW, if this is the case, trigger the registration NUI?
    if (Character_ID == "New") then
        TriggerClientEvent("Client:Character:Create", src)
    elseif Character_ID ~= nil then
        local Coords = c.sql.char.GetCoords(Character_ID)
        c.data.LoadPlayer(src, Character_ID)
        TriggerClientEvent("Client:Character:ReSpawn", src, Coords)
    elseif Character_ID == nil then
        DropPlayer(src, "You dont have a character selected, this is impossible, bye.")
    end
end)

-- [C]
RegisterNetEvent("Server:Character:Delete")
AddEventHandler("Server:Character:Delete", function(Character_ID)
    local src = tonumber(source)
    local primary_id = c.identifier(src)
    c.sql.char.Delete(Character_ID, function()
        DropPlayer(src, "Character with id: "..Character_ID.." was Deleted Successfully, please rejoin.")
    end)
end)

RegisterNetEvent("Server:Character:Failed")
AddEventHandler("Server:Character:Failed", function()
    local src = tonumber(source)
    DropPlayer(src, "Actually make a character...")
end)


-- Need to move this and clean it the fuck up, its gross atm.
-- [S]
RegisterNetEvent("Server:Character:Register")
AddEventHandler("Server:Character:Register", function(first_name, last_name, height, birth_date, appearance)
    local src = tonumber(source)
    -- Run a check to see if it being exploited.
    if c.data.GetPlayer(src) ~= false then
        c.eventban(src, "Server:Character:Register")
    end
    local p = promise.new()
    local character_id = c.sql.gen.CharacterID()
    local city_id = c.sql.gen.CityID()
    local phone_number = c.sql.gen.PhoneNumber()
    local bank_number = c.sql.gen.AccountNumber()
    local primary_id = c.identifier(src)
    local data = {}
    
    data.Primary_ID = primary_id -- Owner
    data.Character_ID = character_id -- Unique ID
    data.First_Name = first_name
    data.Last_Name = last_name
    data.Height = height
    data.Birth_Date = birth_date
    data.City_ID = city_id
    data.Phone = phone_number
    data.Coords = json.encode(conf.spawn)
    data.Job = json.encode(conf.default.job)
    data.Accounts = json.encode(conf.default.accounts)
    data.Modifiers = json.encode(conf.default.modifiers)
    data.Appearance = json.encode(appearance)
    
    c.sql.char.Add(data, function()
        -- CHain other required actions upon the initial data being added, like other tables that use forigen keys etc.
        c.sql.bank.AddAccount(character_id, bank_number)
        
        --
        p:resolve()
    end)
    --
    c.data.LoadPlayer(src, character_id)
    --
    Citizen.Await(p)    
    --[[
            ADD YOUR CHARACTER CREATION EVENT BELOW
    ]]--
    TriggerEvent("Server:Character:Spawn", src)
    --[[
            ADD YOUR CHARACTER CREATION EVENT ABOVE
    ]]--
end)

RegisterNetEvent("Server:Character:Spawn")
AddEventHandler("Server:Character:Spawn", function(req)
    local src = tonumber(req)
    local xPlayer = c.data.GetPlayer(src)
    TriggerClientEvent("Client:Character:ReSpawn", src, xPlayer.GetCoords())
end)

RegisterServerEvent("Server:Character:SaveSkin")
AddEventHandler("Server:Character:SaveSkin", function(appearance, bool)
	local src = source
	local xPlayer = c.data.GetPlayer(src)
	local identifier = xPlayer.GetIdentifier()
    c.sql.char.SetAppearance(identifier, appearance, function()
        xPlayer.SetAppearance(appearance)
    end)
    if type(bool) == "boolean" and bool == true then
        c.inst.SetPlayerDefault(src)
    end
end)

RegisterServerEvent("Server:Character:LoadSkin")
AddEventHandler("Server:Character:LoadSkin", function()
	local src = source
	local xPlayer = c.data.GetPlayer(src)
	local appearance = xPlayer.GetAppearance()
	TriggerClientEvent("Client:Character:LoadSkin", src, appearance)
end)

-- Triggered after character has been loaded from db and informaiton is passed to client
-- [C]
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
-- [C] 
RegisterNetEvent("Server:Character:Ready")
AddEventHandler("Server:Character:Ready", function()
    local src = source
    local xPlayer = c.data.GetPlayer(src)
    -- update what instance they are in.
    c.inst.SetPlayer(src, xPlayer.GetInstance())
    -- Remove from current ACL Job Group
    ExecuteCommand(("remove_principal identifier.%s job.%s"):format(xPlayer.GetLicense_ID(), xPlayer.GetJob().Name))
    -- to trigger state updates for clients
    xPlayer.SetJob(xPlayer.GetJob())
    xPlayer.GetCash() -- this triggers state chagnes
    xPlayer.GetBank() -- this triggers state chagnes
end)

-- Use this to remove any things connected to Characters like police blips etc.
-- [C+S]
RegisterNetEvent("Server:Character:Switch")
AddEventHandler("Server:Character:Switch", function(req)
    local src = req or source
    local xPlayer = c.data.GetPlayer(src)
    -- Remove Player Identifier from job as entity if no longer existing.
    ExecuteCommand(("remove_principal identifier.%s job.%s"):format(xPlayer.License_ID, xPlayer.GetJob().Name))
    --

end)

-- Server Death Handler - if was killed by a player or not.
-- [C]
RegisterNetEvent("Server:Character:Death")
AddEventHandler("Server:Character:Death", function(data)
    local src = source
    if data.Log then
        -- agro = source id or -1 for server.
        local agro = data.Log.Source
        if data.Cause == "Weapon" then
            
        elseif data.Cause == "Vehicle" then

        elseif data.Cause == "Obejct" then
            
        end
    else

    end
end)

--@ req = server_id or source
--@ t = {"name"="police","grade"=0}
-- [C+S]
RegisterNetEvent("Server:Character:SetJob")
AddEventHandler("Server:Character:SetJob", function(req, data)
    local src = req or source
    local xPlayer = c.data.GetPlayer(src)
    -- Add New Job command permissions for ACL system
    ExecuteCommand(("add_principal identifier.%s job.%s"):format(xPlayer.GetLicense_ID(), xPlayer.GetJob().Name))
end)