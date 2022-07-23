-- ====================================================================================--

--
SetGameType(conf.gamemode)
SetConvarServerInfo("Game Mode", conf.gamemode)
--
SetMapName(conf.mapname)
SetConvarServerInfo("Map Name", conf.mapname)
--

-- ====================================================================================--
AddEventHandler("onResourceStart", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    --
    c.version.Check(conf.url.version, resourceName)
    -- Run setup / startup by loading data from files the database etc.
    c.data.Initilize()
    --
    while c.Loading do
        Wait(25)
    end
    -- Time now updates
    c.time.ServerSync()
    -- Players save to the DB.
    c.data.ServerSync()
    -- Start allowing dead characters to be revived - called every minute
    c.data.ReviveSync()
    -- Get character values every x seconds.
    c.data.CharacterValues()
    -- Start Paying players based on conf.
    c.job.PayCycle()  
    -- Cleanup Cycles on files.
    c.gsr.CleanUp()
    c.drop.CleanUp()
    c.pick.CleanUp()
    c.note.CleanUp()
    
    --
    Queue.OnReady()
end)
-- ====================================================================================--
RegisterNetEvent("Server:PlayerConnecting")
AddEventHandler("Server:PlayerConnecting", function()
    local src = tonumber(source)
    local Username = GetPlayerName(src)
    local Primary_ID = c.func.identifier(src)
    local Steam_ID, FiveM_ID, License_ID, Discord_ID, IP_Address = c.func.identifiers(src)
    --
    local function Startup()
        TriggerClientEvent("Client:Character:OpeningMenu", src)
        TriggerEvent("Server:Character:List", src, Primary_ID)
    end
    --
    if License_ID then
        c.data.AddPlayer(src)
        -- Lets see if the player exists.
        local exists = c.sql.user.Find(License_ID)
        if (exists == nil) then            
            -- If no user present.    
            c.sql.user.Add(Username, License_ID, FiveM_ID, Steam_ID, Discord_ID, IP_Address, Startup)
        else
            -- If user exists, update based on connection info.
            c.sql.user.Update(Username, License_ID, FiveM_ID, Steam_ID, Discord_ID, IP_Address, Startup)
        end
    else
        DropPlayer(src, "No License Identifier, No Entry.")
    end    
end)
-- ====================================================================================--
AddEventHandler("playerDropped", function()
    local src = tonumber(source)
    local xPlayer = c.data.GetPlayer(src)
    -- if the data not false?
    if xPlayer then
        -- Remove Job Permissions
        ExecuteCommand(("remove_principal identifier.%s job.%s"):format(xPlayer.GetLicense_ID(), xPlayer.GetJob().Name))
        -- Save Data
        c.sql.save.User(xPlayer, function()
            c.sql.char.SetActive(xPlayer.GetIdentifier(), false, function()
                c.func.Debug_1("[E] 'playerDropped' : Player Disconnection.")
                c.data.RemovePlayer(src)
            end)
        end)
        -- NPWD
        --exports["npwd"]:unloadPlayer(src)
    end
end)