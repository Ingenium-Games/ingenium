

RegisterNetEvent("Client:Core:UI")
AddEventHandler("Client:Core:UI", function(message, data)
    c.IsBusyPleaseWait(1000)
    SetNuiFocus(true, true)
    SendNUIMessage({
        message = message,
        data = data
    })
end)