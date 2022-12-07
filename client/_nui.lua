-- ====================================================================================--

-- ====================================================================================--
-- Character Selections

RegisterNUICallback("__Join", function(Data, cb)
    if not Data.ID then CancelEvent() return end
    SetNuiFocus(false, false)
    TriggerServerEvent("Server:Character:Join", Data.ID)
    SetFollowPedCamViewMode(0)
    cb("ok")
end)

-- Not currently in use...
RegisterNUICallback("__Delete", function(Data, cb)
    if not Data.ID then CancelEvent() return end
    SetNuiFocus(false, false)
    TriggerServerEvent("Server:Character:Delete", Data.ID)
    cb("ok")
end)

RegisterNUICallback("__Register", function(Data, cb)
    SetNuiFocus(false, false)
    SetFollowPedCamViewMode(0)
    local appearance = exports["fivem-appearance"]:getPedAppearance(PlayerPedId())
    TriggerServerEvent("Server:Character:Register", Data.First_Name, Data.Last_Name, appearance)
    cb("ok")
end)
