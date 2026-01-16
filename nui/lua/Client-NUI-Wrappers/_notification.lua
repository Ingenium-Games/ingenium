-- ====================================================================================--
-- NOTIFICATION CLIENT-NUI WRAPPER FUNCTIONS
-- ====================================================================================--
-- Centralized wrapper functions for notification/alert system NUI operations.
-- These functions send messages FROM CLIENT TO NUI.
--
-- Call these from client event handlers:
--   - ig.nui.notify.Show(message, notifType, options)  => Client:NUI:NotificationShow
--   - ig.nui.notify.Hide(id)                           => Client:NUI:NotificationHide
--
-- ====================================================================================--

if not ig.nui then ig.nui = {} end
if not ig.nui.notify then ig.nui.notify = {} end

-- Show notification
-- Called from: Client code to display notification/alert
function ig.nui.notify.Show(message, notifType, options)
    local id = notifType .. "_" .. math.random(1000000)
    local duration = 5000
    
    if options then
        if options.duration then
            duration = options.duration
        end
        if options.id then
            id = options.id
        end
    end
    
    ig.ui.Send("Client:NUI:NotificationShow", {
        id = id,
        message = message or "Notification",
        type = notifType or "info",  -- info, success, warning, error
        duration = duration,
        action = options and options.action or nil,
        actionLabel = options and options.actionLabel or "OK"
    }, false)
    
    return id
end

-- Hide/dismiss notification
-- Called from: Client code or notification timeout
function ig.nui.notify.Hide(id)
    ig.ui.Send("Client:NUI:NotificationHide", {
        id = id
    }, false)
end

ig.log.Info("Client-NUI-Wrappers", "Notification wrapper functions loaded")
