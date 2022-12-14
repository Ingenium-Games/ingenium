-- ====================================================================================--
-- [C + S]
RegisterNetEvent("Client:Notify")
AddEventHandler("Client:Notify", function(text, colour, fade)
    local colour = colour or "black"
    local fade = fade or 13500
    local data = {
        text = text,
        colour = colour,
        fade = fade
    }
    TriggerEvent("Client:Nui:Message", "notification", data, false)
end)