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
    --
    ig.vehicle.InitializePersistence()
    --
end)

-- ====================================================================================--
-- Migrated to callback for security
RegisterServerCallback({
    eventName = "Server:PlayerConnecting",
    eventCallback = function(source)
        local src = tonumber(source)
        local Username = GetPlayerName(src)
        local Primary_ID = ig.func.identifier(src)
        local Steam_ID, FiveM_ID, License_ID, Discord_ID, IP_Address = ig.func.identifiers(src)
        --
        local function Startup()
            -- Place player in their own routing bucket BEFORE showing character menu
            -- This prevents them from seeing/hearing other players during character selection
            ig.inst.SetPlayer(src)
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
            return { success = true }
        else
            DropPlayer(src, "No License Identifier, No Entry.")
            return { success = false, error = "No license identifier" }
        end
    end
})
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
                ig.log.Info("Server", "Player disconnection event triggered")
                ig.data.RemovePlayer(src)
            end)
        end)
    end
    -- last player, force save data.
    if not ig.player.ArePlayersActive() then
        --
        ig.sql.save.Vehicles()
        ig.debug.Info("SQL: Vehicles")
        Citizen.Wait(conf.sec)
        --
        ig.vehicle.SavePersistentVehicles()
        ig.debug.Info("JSON: Persistent Vehicles")
        --
        ig.sql.veh.Reset()
        ig.sql.char.ResetActive()
        --
    end
end)
