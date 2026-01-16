-- ====================================================================================--
-- APPEARANCE NUI→CLIENT CALLBACK HANDLERS
-- ====================================================================================--
-- Processes messages FROM NUI TO CLIENT for appearance operations.
--
-- NUI sends these messages:
--   - NUI:Client:AppearanceComplete  => Character appearance customization done
--
-- ====================================================================================--

-- Player completes appearance customization in NUI
-- Sent from: nui/src/components/AppearanceCustomizer.vue
RegisterNUICallback('NUI:Client:AppearanceComplete', function(data, cb)
    if not data or not data.appearance then
        ig.log.Error("Appearance", "NUI:Client:AppearanceComplete: missing appearance data")
        cb({ok = false, error = "Missing appearance data"})
        return
    end
    
    ig.log.Trace("Appearance", "Appearance customization complete")
    
    -- Get the mode (create or customize)
    local mode = data.mode or "customize"
    
    if mode == "create" then
        -- New character creation - send to server to register
        -- NOTE: Server handler in server/[Events]/_character_lifecycle.lua processes Server:Character:Register
        TriggerServerEvent("Server:Character:Register", data.first_name, data.last_name, data.appearance)
    elseif mode == "customize" then
        -- Existing character appearance update
        -- NOTE: Server handler in server/[Events]/_character_lifecycle.lua processes Server:Character:SaveAppearance
        TriggerServerEvent("Server:Character:SaveAppearance", data.appearance)
    end
    
    -- Close NUI and release focus
    SetNuiFocus(false, false)
    
    cb({ok = true})
end)

ig.log.Info("NUI-Client", "Appearance callbacks registered")
