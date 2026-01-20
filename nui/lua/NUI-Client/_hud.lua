-- ====================================================================================--
-- HUD NUI→CLIENT CALLBACK HANDLERS
-- ====================================================================================--
-- Processes messages FROM NUI TO CLIENT for HUD operations.
--
-- NUI sends these messages:
--   - NUI:Client:HUDClose      => HUD was closed/hidden
--   - NUI:Client:HUDUpdate     => HUD element updated by user
--   - NUI:Client:HUDInteraction => Player interacted with HUD element
--
-- ====================================================================================--

-- Player closes/hides HUD
-- Sent from: nui/src/components/HUD.vue
RegisterNUICallback('NUI:Client:HUDClose', function(data, cb)
    ig.log.Trace("HUD", "HUD closed")
    
    -- Close NUI and release focus
    SetNuiFocus(false, false)
    
    -- Trigger internal event for HUD cleanup
    TriggerEvent("Client:HUD:Close")
    
    cb({ok = true})
end)

-- HUD element was updated by player interaction
-- Sent from: nui/src/components/HUD.vue with element data
RegisterNUICallback('NUI:Client:HUDUpdate', function(data, cb)
    if not data or not data.element then
        ig.log.Error("HUD", "NUI:Client:HUDUpdate: missing element data")
        cb({ok = false, error = "Missing element data"})
        return
    end
    
    -- Trigger element-specific update event
    TriggerEvent("Client:HUD:Update", data)
    
    cb({ok = true})
end)

-- Player interacted with HUD element
-- Sent from: nui/src/components/HUD.vue with interaction data
RegisterNUICallback('NUI:Client:HUDInteraction', function(data, cb)
    if not data or not data.action then
        ig.log.Error("HUD", "NUI:Client:HUDInteraction: missing action data")
        cb({ok = false, error = "Missing action"})
        return
    end
    
    ig.log.Trace("HUD", "HUD interaction: " .. data.action)
    
    -- Trigger action handler
    TriggerEvent("Client:HUD:Action", data)
    
    cb({ok = true})
end)

ig.log.Info("NUI-Client", "HUD callbacks registered")
