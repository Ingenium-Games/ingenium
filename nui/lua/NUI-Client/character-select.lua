-- ====================================================================================--
-- CHARACTER NUI→CLIENT CALLBACK HANDLERS
-- ====================================================================================--
-- Processes messages FROM NUI TO CLIENT for character operations.
-- These callbacks receive data from NUI and communicate with the server.
--
-- NUI sends these messages:
--   - NUI:Client:CharacterPlay      => TriggerServerEvent("Server:Character:Join")
--   - NUI:Client:CharacterDelete    => TriggerServerEvent("Server:Character:Delete")
--   - NUI:Client:CharacterCreate    => TriggerServerEvent("Server:Character:Register")
--
-- ====================================================================================--

-- Player selects an existing character from NUI
RegisterNUICallback("NUI:Client:CharacterPlay", function(data, cb)
    if not data.ID then
        cb({
            message = "error",
            data = "NUI:Client:CharacterPlay: missing data.ID"
        })
        return
    end
    
    -- Verify player is not already loaded
    if not ig.data.IsPlayerLoaded() then
        SetNuiFocus(false, false)
        ig.log.Trace("Character", "NUI: Player selected character " .. data.ID)
        
        -- Send to server for validation and loading
        -- NOTE: server/[Events]/_character_lifecycle.lua handles Server:Character:Join
        TriggerServerEvent("Server:Character:Join", data.ID)
        
        SetFollowPedCamViewMode(0)
        cb({
            message = "ok",
            data = nil
        })
    else
        cb({
            message = "error",
            data = "NUI:Client:CharacterPlay: Player already has a character loaded"
        })
    end
end)

-- Player deletes a character from NUI
RegisterNUICallback("NUI:Client:CharacterDelete", function(data, cb)
    if not data.ID then
        cb({
            message = "error",
            data = "NUI:Client:CharacterDelete: missing data.ID"
        })
        return
    end
    
    -- Verify player is not already loaded
    if not ig.data.IsPlayerLoaded() then
        SetNuiFocus(false, false)
        ig.log.Trace("Character", "NUI: Player deleting character " .. data.ID)
        
        -- Send to server for validation and deletion
        -- NOTE: server/[Events]/_character_lifecycle.lua handles Server:Character:Delete
        TriggerServerEvent("Server:Character:Delete", data.ID)
        
        cb({
            message = "ok",
            data = nil
        })
    else
        cb({
            message = "error",
            data = "NUI:Client:CharacterDelete: Player already has a character loaded"
        })
    end
end)

-- Player creates a new character from NUI
RegisterNUICallback("NUI:Client:CharacterCreate", function(data, cb)
    -- Verify player is not already loaded
    if not ig.data.IsPlayerLoaded() then
        SetNuiFocus(false, false)
        ig.log.Trace("Character", "NUI: Player creating new character")
        
        -- Get appearance from nui/src/stores/appearance.js (user customization)
        local appearance = ig.appearance.PendingAppearance or ig.appearance.GetAppearance()
        ig.appearance.PendingAppearance = nil
        
        SetFollowPedCamViewMode(0)
        
        -- Send to server with character data and appearance
        -- NOTE: server/[Events]/_character_lifecycle.lua handles Server:Character:Register
        TriggerServerEvent("Server:Character:Register", data.First_Name, data.Last_Name, appearance)
        
        cb({
            message = "ok",
            data = nil
        })
    else
        cb({
            message = "error",
            data = "NUI:Client:CharacterCreate: Player already has a character loaded"
        })
    end
end)

ig.log.Info("NUI-Client", "Character callbacks registered")
