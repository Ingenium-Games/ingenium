-- ====================================================================================--
-- MENU NUI→CLIENT CALLBACK HANDLERS
-- ====================================================================================--
-- Processes messages FROM NUI TO CLIENT for menu operations.
--
-- NUI sends these messages:
--   - NUI:Client:MenuClose     => Menu was closed by player (ESC or close button)
--   - NUI:Client:MenuSelect    => Player selected menu option
--
-- ====================================================================================--

-- Player closes menu via ESC or close button
-- Sent from: nui/src/components/Menu.vue
RegisterNUICallback('NUI:Client:MenuClose', function(data, cb)
    ig.log.Trace("Menu", "Menu closed")
    
    -- Close NUI and release focus
    SetNuiFocus(false, false)
    
    -- Trigger internal event for menu cleanup
    TriggerEvent("Client:Menu:Close")
    
    cb({ok = true})
end)

-- Player selects menu option
-- Sent from: nui/src/components/Menu.vue with selected option data
RegisterNUICallback('NUI:Client:MenuSelect', function(data, cb)
    if not data or not data.action then
        ig.log.Error("Menu", "NUI:Client:MenuSelect: missing action data")
        cb({ok = false, error = "Missing action"})
        return
    end
    
    ig.log.Trace("Menu", "Menu option selected: " .. data.action)
    
    -- Trigger action-specific events or handlers
    TriggerEvent("Client:Menu:Select", data)
    
    cb({ok = true})
end)

ig.log.Info("NUI-Client", "Menu callbacks registered")
