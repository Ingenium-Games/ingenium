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

RegisterNUICallback("__close", function(Data, cb)
    -- Check if player is loaded as acharacter, otherwise dont disable nui, itll be in the character seleciton screen.
    if c.data.IsPlayerLoaded() then
        SetNuiFocus(false, false)
        cb({message = "ok"})
    else
        cb({error = "__close called with no loaded character" })
    end
end)
