-- ====================================================================================--
-- Notifications 
local colours = {"black", "blue", "orange", "red", "green", "pink", "purple", "yellow"}
-- Send Update to HTML NUI Notification - Still to make.
-- [C+S]
RegisterNetEvent("Client:Notify")
AddEventHandler("Client:Notify", function(text, colour, fade)
    if not colours[colour] then
        colour = "black"
    end
    if not fade then
        fade = 13500
    end
    local data = {
        text = text,
        colour = colour,
        fade = fade
    }
    TriggerEvent("Client:Nui:Message", "notification", data, false)
end)