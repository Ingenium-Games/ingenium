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
    ig.version.Check(conf.url.version, resourceName)
end)

AddEventHandler('ig:sql:ready', function()
    --
    ig.data.Initilize()
    --
    while ig._loading do
        Wait(25)
    end
    -- Time now updates
    ig.time.ServerSync()
    -- Players save to the DB.
    ig.data.ServerSync()
    -- Start allowing dead characters to be revived - called every minute
    ig.data.ReviveSync()
    -- Get character values every x seconds.
    ig.data.CharacterValues()
    -- Start Paying players based on conf.
    ig.job.PayCycle()
    -- Cleanup Cycles on files.
    ig.gsr.CleanUp()
    ig.drop.CleanUp()
    ig.pick.CleanUp()
    ig.note.CleanUp()
    --
    Queue.OnReady()
end)


-- ====================================================================================--
RegisterNetEvent("Server:PlayerConnecting")
AddEventHandler("Server:PlayerConnecting", function()
    local src = tonumber(source)
    local Username = GetPlayerName(src)
    local Primary_ID = ig.func.identifier(src)
    local Steam_ID, FiveM_ID, License_ID, Discord_ID, IP_Address = ig.func.identifiers(src)
    --
    local function Startup()
        TriggerClientEvent("Client:Character:OpeningMenu", src)
        TriggerEvent("Server:Character:List", src, Primary_ID)
    end
    --
    if License_ID then
        ig.data.AddPlayer(src)
        -- Lets see if the player exists.
        local exists = ig.sql.user.Find(License_ID)
        if (exists == nil) then
            -- If no user present.    
            ig.sql.user.Add(Username, License_ID, FiveM_ID, Steam_ID, Discord_ID, IP_Address, Startup)
        else
            -- If user exists, update based on connection info.
            ig.sql.user.Update(Username, License_ID, FiveM_ID, Steam_ID, Discord_ID, IP_Address, Startup)
        end
    else
        DropPlayer(src, "No License Identifier, No Entry.")
    end
end)
-- ====================================================================================--
AddEventHandler("playerDropped", function()
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    -- if the data not false?
    if xPlayer then
        -- Remove Job Permissions
        ExecuteCommand(("remove_principal identifier.%s job.%s"):format(xPlayer.GetLicense_ID(), xPlayer.GetJob().Name))
        -- Save Data
        ig.sql.save.User(xPlayer, function()
            ig.sql.char.SetActive(xPlayer.GetIdentifier(), false, function()
                ig.func.Debug_1("[E] 'playerDropped' : Player Disconnection.")
                ig.data.RemovePlayer(src)
            end)
        end)
    end
    -- last player, force save data.
    if not ig.data.ArePlayersActive() then
        --
        ig.sql.save.Vehicles()
        print("   ^7[^5SQL^7]: Vehicles")
        Citizen.Wait(conf.sec)
        --
        ig.sql.veh.Reset()
        ig.sql.ResetActiveCharacters()
        --
    end
end)
