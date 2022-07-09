RegisterNetEvent("Client:Core:UI")
AddEventHandler("Client:Core:UI", function(M, D)
    if not D then D = {} end
    c.func.IsBusyPleaseWait(1000)
    SendNUIMessage({
        message = M,
        data = D
    })
    
    if M == "Joining" then
        c.func.FadeOut(1000)
        ShutdownLoadingScreenNui()
        c.func.FadeIn(2000)
        SetNuiFocus(true, true)
    else
        SetNuiFocus(true, true)
    end
end)