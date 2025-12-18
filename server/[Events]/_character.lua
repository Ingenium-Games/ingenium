-- ====================================================================================--

--  Get Character Info for the NUI to allow character selection.
-- [C+S]
RegisterNetEvent("Server:Character:List", function(req, Primary_ID)
    local src = tonumber(req) or source
    local p = promise.new()
    local Slots = ig.sql.user.GetSlots(Primary_ID)
    local Characters = ig.sql.char.GetAllPermited(Primary_ID, Slots)
    p:resolve()
    Citizen.Await(p)
    -- Send the data table to the client that requested it...
    TriggerClientEvent("Client:Nui:Message", src, "connected", {["Characters"] = Characters, ["Slots"] = Slots})
    -- Place the user in their own instance until the user has joined and loaded.
    ig.inst.SetPlayer(src)
end)

-- [C]
RegisterNetEvent("Server:Character:Join", function(Character_ID)
    local src = tonumber(source)
    -- If the User selected the NEW button on the NUI, the Character_ID will be listed as NEW, if this is the case, trigger the registration NUI?
    if (Character_ID == "New") then
        TriggerClientEvent("Client:Character:Create", src)
    elseif Character_ID ~= nil then
        local Coords = ig.sql.char.GetCoords(Character_ID)
        ig.data.LoadPlayer(src, Character_ID)
        TriggerClientEvent("Client:Character:ReSpawn", src, Coords)
    elseif Character_ID == nil then
        DropPlayer(src, "You dont have a character selected, this is impossible, bye.")
    end
end)

-- [C]
RegisterNetEvent("Server:Character:Delete", function(Character_ID)
    local src = tonumber(source)
    local primary_id = ig.funig.identifier(src)
    ig.sql.char.Delete(Character_ID, function()
        DropPlayer(src, "Character with id: "..Character_ID.." was Deleted Successfully, please rejoin.")
    end)
end)

RegisterNetEvent("Server:Character:Failed", function()
    local src = tonumber(source)
    DropPlayer(src, "Actually make a character...")
end)


-- Need to move this and clean it the fuck up, its gross atm.
-- [S]
RegisterNetEvent("Server:Character:Register", function(first_name, last_name, appearance)
    local src = tonumber(source)
    -- Run a check to see if it being exploited.
    if ig.data.GetPlayer(src) ~= false then
        ig.funig.Eventban(src, "Server:Character:Register")
    end
    local p = promise.new()
    local character_id = ig.sql.gen.CharacterID()
    local city_id = ig.sql.gen.CityID()
    local phone_number = ig.sql.gen.PhoneNumber()
    local iban = ig.sql.gen.Iban()
    local bank_number = ig.sql.gen.AccountNumber()
    local primary_id = ig.funig.identifier(src)
    local data = {}
    
    data.Primary_ID = primary_id -- Owner
    data.Character_ID = character_id -- Unique ID
    data.First_Name = first_name
    data.Last_Name = last_name
    data.City_ID = city_id
    data.Phone = phone_number
    data.Iban = iban
    data.Coords = json.encode(conf.spawn)
    data.Job = json.encode(conf.default.job)
    data.Accounts = json.encode(conf.default.accounts)
    data.Modifiers = json.encode(conf.default.modifiers)
    data.Skills = json.encode(conf.default.skills)
    data.Appearance = json.encode(appearance)
    
    ig.sql.char.Add(data, function()
        -- CHain other required actions upon the initial data being added, like other tables that use forigen keys etig.
        ig.sql.bank.AddAccount(character_id, bank_number)
        --
        p:resolve()
    end)
    --
    ig.data.LoadPlayer(src, character_id)
    --
    Citizen.Await(p)    
    --[[
            ADD YOUR CHARACTER CREATION EVENT BELOW
    ]]--
    TriggerEvent("Server:Character:Spawn", src)
    --[[
            ADD YOUR CHARACTER CREATION EVENT ABOVE
    ]]--
    local xPlayer = ig.data.GetPlayer(src)
    xPlayer.AddItem({"Phone",1,100})
end)

RegisterNetEvent("Server:Character:Spawn", function(req)
    local src = tonumber(req)
    local xPlayer = ig.data.GetPlayer(src)
    TriggerClientEvent("Client:Character:ReSpawn", src, xPlayer.GetCoords())
end)

RegisterNetEvent("Server:Character:SaveSkin", function(appearance, bool)
	local src = source
	local xPlayer = ig.data.GetPlayer(src)
	local identifier = xPlayer.GetIdentifier()
    ig.sql.char.SetAppearance(identifier, appearance, function()
        xPlayer.SetAppearance(appearance)
    end)
    if type(bool) == "boolean" and bool == true then
        ig.inst.SetPlayerDefault(src)
    end
end)

-- Save appearance with validation (new system)
RegisterNetEvent("Server:Character:SaveAppearance", function(appearance)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        print('^1[Appearance] No xPlayer found for source: ' .. src .. '^0')
        return
    end
    
    -- Validate appearance data
    local isValid, errorMsg = ig.appearance.ValidateAppearance(appearance)
    if not isValid then
        print('^1[Appearance] Invalid appearance data for ' .. xPlayer.GetIdentifier() .. ': ' .. errorMsg .. '^0')
        TriggerClientEvent('Client:Nui:Message', src, 'notification', {
            text = 'Invalid appearance data: ' .. errorMsg,
            color = 'red',
            fade = 5000
        })
        return
    end
    
    -- Save to database
    local identifier = xPlayer.GetIdentifier()
    ig.sql.char.SetAppearance(identifier, appearance, function()
        xPlayer.SetAppearance(appearance)
        print('^2[Appearance] Saved appearance for ' .. identifier .. '^0')
    end)
end)

RegisterNetEvent("Server:Character:LoadSkin", function()
	local src = source
	local xPlayer = ig.data.GetPlayer(src)
	local appearance = xPlayer.GetAppearance()
	TriggerClientEvent("Client:Character:LoadSkin", src, appearance)
end)

-- Triggered after character has been loaded from db and informaiton is passed to client
-- [C]
RegisterNetEvent("Server:Character:Loaded", function()
    local src = source
    local ped = GetPlayerPed(src)
    local xPlayer = ig.data.GetPlayer(src)

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
RegisterNetEvent("Server:Character:Ready", function()
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    -- update what instance they are in.
    ig.inst.SetPlayer(src, xPlayer.GetInstance())
    -- Remove from current ACL Job Group
    ExecuteCommand(("remove_principal identifier.%s job.%s"):format(xPlayer.GetIdentifier(), xPlayer.GetJob().Name))
    -- to trigger state updates for clients
    local job = xPlayer.GetJob()
    xPlayer.SetJob(job.Name, job.Grade)
    xPlayer.GetCash() -- this triggers state changes
    xPlayer.GetBank() -- this triggers state changes    
end)

-- Use this to remove any things connected to Characters like police blips etig.
-- [C+S]
RegisterNetEvent("Server:Character:Switch", function(req)
    local src = req or source
    local xPlayer = ig.data.GetPlayer(src)
    -- Remove Player Identifier from job as entity if no longer existing.
    ExecuteCommand(("remove_principal identifier.%s job.%s"):format(xPlayer.GetIdentifier(), xPlayer.GetJob().Name))
    --

end)

-- Server Death Handler - if was killed by a player or not.
-- [C]
RegisterNetEvent("Server:Character:Death", function(data)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    -- Death SQL added the state bag change handler
    -- Mark as dead within DB
    ig.sql.char.SetDead(xPlayer.GetCharacter_ID(), true, data)
    --
    if data.Log then
        -- agro = source id or -1 for server.
        local agro = data.Log.Source
        if data.Cause == "Weapon" then

        elseif data.Cause == "Vehicle" then

        elseif data.Cause == "Obejct" then
            
        end
    end
    xPlayer.Notify("You have been downed, you must wait for someone to assist you.", "black", 15000)
    xPlayer.Notify("If you do not wait, or leave, you will be unable to use this character for 7 days.", "red", 10000)
end)

--@ req = server_id or source
--@ t = {"name"="police","grade"=0}
-- [C+S]
RegisterNetEvent("Server:Character:SetJob", function(req, data)
    local src = req or source
    local xPlayer = ig.data.GetPlayer(src)
    -- Force set to false incase already employeed
    xPlayer.SetDuty(false)
    -- Add New Job command permissions for ACL system
    ExecuteCommand(("add_principal identifier.%s job.%s"):format(xPlayer.GetLicense_ID(), xPlayer.GetJob().Name))
    -- If unemployed
    if data.Name == "none" then
        xPlayer.SetDuty(true)
    end
end)

RegisterNetEvent("Server:Character:Duty", function(boolean)
    if conf.enableduty then
        -- Add Functions or Hooks here!
        local bool = boolean
        local src = source
        local xPlayer = ig.data.GetPlayer(src)
        xPlayer.SetDuty(bool)
    else
        ig.funig.Debug_3("Ability to go on/off duty has ben disabled.")
    end
end)