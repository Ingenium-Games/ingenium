-- ====================================================================================--
-- INPUT NUI→CLIENT CALLBACK HANDLERS
-- ====================================================================================--
-- Processes messages FROM NUI TO CLIENT for input/dialog operations.
--
-- NUI sends these messages:
--   - NUI:Client:InputClose    => Input dialog was closed by player
--   - NUI:Client:InputSubmit   => Player submitted input value
--
-- ====================================================================================--

-- Player closes input dialog via ESC or close button
-- Sent from: nui/src/components/Input.vue
RegisterNUICallback('NUI:Client:InputClose', function(data, cb)
    ig.log.Trace("Input", "Input dialog closed")
    
    -- Close NUI and release focus
    SetNuiFocus(false, false)
    
    -- Trigger internal event for input cleanup
    TriggerEvent("Client:Input:Close")
    
    cb({ok = true})
end)

-- Player submits input value
-- Sent from: nui/src/components/Input.vue with text value
RegisterNUICallback('NUI:Client:InputSubmit', function(data, cb)
    if not data or not data.value then
        ig.log.Error("Input", "NUI:Client:InputSubmit: missing value data")
        cb({ok = false, error = "Missing value"})
        return
    end
    
    ig.log.Trace("Input", "Input submitted: " .. tostring(data.value):sub(1, 20))
    
    -- Close NUI and release focus
    SetNuiFocus(false, false)
    
    -- Trigger internal event with submitted value
    TriggerEvent("Client:Input:Submit", data.value)
    
    cb({ok = true})
end)

ig.log.Info("NUI-Client", "Input callbacks registered")
