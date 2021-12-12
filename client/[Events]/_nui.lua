

RegisterNetEvent("Client:Core:UI")
AddEventHandler("Client:Core:UI", function(M, D)
    if not D then D = {} end
    c.IsBusyPleaseWait(1000)
    SendNUIMessage({
        message = M,
        data = D
    })
    SetNuiFocus(true, true)
    if M == "Joining" then
        ShutdownLoadingScreenNui()
    end
end)