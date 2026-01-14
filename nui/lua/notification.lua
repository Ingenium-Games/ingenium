-- ====================================================================================--
-- Notification helper (export + restricted event)
local function sendNotification(text, colour, fade)
    local colour = colour or "black"
    local fade = fade or 13500
    local data = {
        text = text,
        colour = colour,
        fade = fade
    }
    SendNUIMessage({ message = "Client:NUI:Notification", data = data })
end

-- Register as a client callback so external resources can invoke via TriggerClientCallback
RegisterClientCallback({
    eventName = "Client:Notify",
    eventCallback = function(text, colour, fade)
        sendNotification(text, colour, fade)
    end
})

-- Backwards-compatible local net event for internal code and server
RegisterNetEvent("Client:Notify")
AddEventHandler("Client:Notify", function(text, colour, fade)
    local inv = GetInvokingResource()
    if inv ~= nil and inv ~= conf.resourcename then
        CancelEvent()
        return
    end
    sendNotification(text, colour, fade)
end)

-- Export for other resources to call explicitly
exports('Notify', function(text, colour, fade)
    sendNotification(text, colour, fade)
end)