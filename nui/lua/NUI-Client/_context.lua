-- ====================================================================================--
-- CONTEXT MENU NUI→CLIENT CALLBACK HANDLERS
-- ====================================================================================--
-- Processes messages FROM NUI TO CLIENT for context menu operations.
--
-- NUI sends these messages:
--   - NUI:Client:ContextClose  => Context menu was closed by player
--   - NUI:Client:ContextSelect => Player selected context menu option
--
-- ====================================================================================--

-- Player closes context menu via ESC or clicking outside
-- Sent from: nui/src/components/ContextMenu.vue
RegisterNUICallback('NUI:Client:ContextClose', function(data, cb)
    ig.log.Trace("Context", "Context menu closed")
    
    -- Close NUI and release focus
    SetNuiFocus(false, false)
    
    -- Trigger internal event for context cleanup
    TriggerEvent("Client:Context:Close")
    
    cb({ok = true})
end)

-- Player selects context menu option
-- Sent from: nui/src/components/ContextMenu.vue with option data
RegisterNUICallback('NUI:Client:ContextSelect', function(data, cb)
    if not data or not data.action then
        ig.log.Error("Context", "NUI:Client:ContextSelect: missing action data")
        cb({ok = false, error = "Missing action"})
        return
    end
    
    ig.log.Trace("Context", "Context option selected: " .. data.action)
    
    -- Trigger action-specific events or handlers
    TriggerEvent("Client:Context:Select", data)
    
    cb({ok = true})
end)

ig.log.Info("NUI-Client", "Context menu callbacks registered")
