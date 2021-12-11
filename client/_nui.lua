-- ====================================================================================--

--[[
NOTES.
    -
    -
    -
]] --

-- ====================================================================================--
-- Character Selections

RegisterNUICallback("Client:Character:Join", function(Data, cb)
    if not Data.ID then CancelEvent() return end
    SetNuiFocus(false, false)
    TriggerServerEvent("Server:Character:Join", Data.ID)
    cb("ok")
end)

-- Not currently in use...
RegisterNUICallback("Client:Character:Delete", function(Data, cb)
    if not Data.ID then CancelEvent() return end
    SetNuiFocus(false, false)
    TriggerServerEvent("Server:Character:Delete", Data.ID)
    cb("ok")
end)

RegisterNUICallback("Client:Character:Register", function(Data, cb)
    SetNuiFocus(false, false)
    DoScreenFadeOut(2000)
    c.IsBusyPleaseWait(2000)
    local appearance = exports["fivem-appearance"]:getPlayerAppearance()
    TriggerServerEvent("Server:Character:Register", Data.First_Name, Data.Last_Name, Data.Height, Data.Birth_Date, appearance)
    cb("ok")
end)
