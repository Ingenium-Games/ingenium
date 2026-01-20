-- ====================================================================================--
-- CHAT NUI→CLIENT CALLBACK HANDLERS
-- ====================================================================================--
-- Processes messages FROM NUI TO CLIENT for chat operations.
--
-- NUI sends these messages:
--   - NUI:Client:ChatSubmit    => Player submitted chat message
--   - NUI:Client:ChatClose     => Chat UI was closed
--
-- ====================================================================================--

-- Player submits chat message
-- Sent from: nui/src/components/Chat.vue with message text
RegisterNUICallback('NUI:Client:ChatSubmit', function(data, cb)
    if not data or not data.message then
        ig.log.Error("Chat", "NUI:Client:ChatSubmit: missing message data")
        cb({ok = false, error = "Missing message"})
        return
    end
    
    local message = tostring(data.message):sub(1, 500)  -- Limit message length
    ig.log.Trace("Chat", "Chat message submitted: " .. message:sub(1, 30))
    
    -- Release NUI focus immediately
    SetNuiFocus(false, false)
    
    -- Send message to server for broadcast
    TriggerServerEvent("Server:Chat:Send", message)
    
    cb({ok = true})
end)

-- Player closes chat UI
-- Sent from: nui/src/components/Chat.vue
RegisterNUICallback('NUI:Client:ChatClose', function(data, cb)
    ig.log.Trace("Chat", "Chat UI closed")
    
    -- Close NUI and release focus
    SetNuiFocus(false, false)
    
    -- Trigger internal event for chat cleanup
    TriggerEvent("Client:Chat:Close")
    
    -- Trigger event to reset chat state (for T key responsiveness)
    TriggerEvent('Client:Chat:Closed')
    
    cb({ok = true})
end)

ig.log.Info("NUI-Client", "Chat callbacks registered")
