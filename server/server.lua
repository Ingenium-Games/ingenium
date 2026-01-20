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
    -- Players save to the DB (prepared queries initialize in background thread)
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
        -- Run funciton AFTER clients data is registered within the database.
        local function ClientDataCollected()
            -- Place player in their own routing bucket BEFORE showing character menu
            -- This prevents them from seeing/hearing other players during character selection
            ig.inst.SetPlayer(src)
            TriggerClientEvent("Client:Character:OpeningMenu", src)
            ExecuteCommand(("add_principal identifier.%s group.public"):format(Primary_ID))
        end
        --
        if License_ID then
            ig.data.AddPlayer(src)
            -- Lets see if the player exists.
            local exists = ig.sql.user.Find(License_ID)
            if (exists == nil) then
                -- If no user present.    
                ig.sql.user.Add(Username, License_ID, FiveM_ID, Steam_ID, Discord_ID, IP_Address, ClientDataCollected)
            else
                -- If user exists, update based on connection info.
                ig.sql.user.Update(Username, License_ID, FiveM_ID, Steam_ID, Discord_ID, IP_Address, ClientDataCollected)
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
    local Primary_ID = ig.func.identifier(src)
    ExecuteCommand(("remove_principal identifier.%s group.public"):format(Primary_ID))
    
    -- Remove from loaded players tracking
    for i, playerId in ipairs(ig._loadedPlayers) do
        if playerId == src then
            table.remove(ig._loadedPlayers, i)
            ig.log.Debug("Server", "Player " .. src .. " removed from loaded players list (\" .. #ig._loadedPlayers .. \" remaining)")
            break
        end
    end
    --
    local xPlayer = ig.data.GetPlayer(src)
    -- if the data not false?
    if xPlayer then
        -- Remove Job Permissions
        ExecuteCommand(("remove_principal identifier.%s job.%s"):format(xPlayer.GetLicense_ID(), xPlayer.GetJob().Name))
        -- Save Data
        ig.sql.save.User(xPlayer, function()
            ig.sql.char.SetActive(xPlayer.GetCharacter_ID(), false, function()
                ig.log.Info("Server", "Player disconnection event triggered")
                ig.data.RemovePlayer(src)
            end)
        end)
    end

    -- last player, force save data.
    if not ig.player.ArePlayersActive() then
        --
        ig.sql.save.Vehicles()
        ig.log.Info("SERVER", "SQL: Vehicles")
        Citizen.Wait(conf.sec)
        --
        ig.vehicle.SavePersistentVehicles()
        ig.log.Info("SERVER", "JSON: Persistent Vehicles")
        --
        ig.sql.veh.Reset()
        ig.sql.char.ResetActive()
        --
    end
end)
