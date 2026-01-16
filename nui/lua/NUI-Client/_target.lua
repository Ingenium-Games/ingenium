-- ====================================================================================--
-- TARGET NUI→CLIENT CALLBACK HANDLERS
-- ====================================================================================--
-- Processes messages FROM NUI TO CLIENT for targeting/interaction.
--
-- NUI sends these messages:
--   - NUI:Client:TargetClose   => Target menu was closed
--   - NUI:Client:TargetSelect  => Player selected target action
--
-- ====================================================================================--

-- Player closes target menu
-- Sent from: nui/src/components/Target.vue
RegisterNUICallback('NUI:Client:TargetClose', function(data, cb)
    ig.log.Trace("Target", "Target menu closed")
    
    -- Close NUI and release focus
    SetNuiFocus(false, false)
    
    -- Trigger internal event for target cleanup
    TriggerEvent("Client:Target:Close")
    
    cb({ok = true})
end)

-- Player selects target action
-- Sent from: nui/src/components/Target.vue with action data
RegisterNUICallback('NUI:Client:TargetSelect', function(data, cb)
    if not data or not data.action then
        ig.log.Error("Target", "NUI:Client:TargetSelect: missing action data")
        cb({ok = false, error = "Missing action"})
        return
    end
    
    ig.log.Trace("Target", "Target action selected: " .. data.action)
    
    -- Trigger action handler
    TriggerEvent("Client:Target:SelectAction", data)
    
    cb({ok = true})
end)

ig.log.Info("NUI-Client", "Target callbacks registered")
