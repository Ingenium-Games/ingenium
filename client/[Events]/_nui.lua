

RegisterNetEvent("Client:Core:UI")
AddEventHandler("Client:Core:UI", function(M, D)
    if not D then D = {} end
    c.IsBusyPleaseWait(1000)
    SendNUIMessage({
        message = M,
        data = D
    })
    
    if M == "Joining" then
        DoScreenFadeOut(1000)
        c.IsBusyPleaseWait(1000)
        ShutdownLoadingScreenNui()
        DoScreenFadeIn(1000)
        c.IsBusyPleaseWait(1000)
        SetNuiFocus(true, true)
    else
        SetNuiFocus(true, true)
    end
end)