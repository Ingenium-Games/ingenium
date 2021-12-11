

RegisterNetEvent("Client:Core:UI")
AddEventHandler("Client:Core:UI", function(M, D)
    c.IsBusyPleaseWait(1000)
    SetNuiFocus(true, true)
    SendNUIMessage({
        message = M,
        data = D
    })
end)