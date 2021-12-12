

RegisterNetEvent("Client:Core:UI")
AddEventHandler("Client:Core:UI", function(M, D)
    if not D then D = {} end
    if M == "Joining" then
        ShutdownLoadingScreenNui()
    end
    c.IsBusyPleaseWait(1000)
    SetNuiFocus(false, false)
    SetNuiFocus(true, true)
    SendNUIMessage({
        message = M,
        data = D
    })
end)