-- ====================================================================================--
-- NOTIFICATION NUI→CLIENT CALLBACK HANDLERS
-- ====================================================================================--
-- Processes messages FROM NUI TO CLIENT for notification/alert operations.
--
-- NUI sends these messages:
--   - NUI:Client:NotificationClose   => Notification was dismissed
--   - NUI:Client:NotificationAction  => Player clicked notification action button
--
-- ====================================================================================--

-- Player dismisses notification
-- Sent from: nui/src/components/Notification.vue
RegisterNUICallback('NUI:Client:NotificationClose', function(data, cb)
    if not data or not data.id then
        ig.log.Error("Notification", "NUI:Client:NotificationClose: missing id")
        cb({ok = false, error = "Missing notification id"})
        return
    end
    
    ig.log.Trace("Notification", "Notification dismissed: " .. data.id)
    
    -- Trigger notification close event
    TriggerEvent("Client:Notification:Closed", data.id)
    
    cb({ok = true})
end)

-- Player clicked action button on notification
-- Sent from: nui/src/components/Notification.vue with action data
RegisterNUICallback('NUI:Client:NotificationAction', function(data, cb)
    if not data or not data.id or not data.action then
        ig.log.Error("Notification", "NUI:Client:NotificationAction: missing action data")
        cb({ok = false, error = "Missing action data"})
        return
    end
    
    ig.log.Trace("Notification", "Notification action: " .. data.id .. " -> " .. data.action)
    
    -- Trigger action handler
    TriggerEvent("Client:Notification:Action", data.id, data.action)
    
    cb({ok = true})
end)

ig.log.Info("NUI-Client", "Notification callbacks registered")
