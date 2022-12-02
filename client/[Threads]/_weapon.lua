
-- Modify ammo counts and trigger ammo updates to server.
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        Citizen.Wait(0)
        if IsPedArmed(ped, 4 | 2) then
            if IsPedShooting(ped) then
                if c._weapon ~= nil and c._ammotype ~= nil then
                    c._ammo[c._ammotype] = c._ammo[c._ammotype] - 1
                end
                Citizen.Wait(115)
            end
            if IsPedReloading(ped) then
                if c._weapon ~= nil then
                    TriggerServerCallback({
                        eventName = "UpdateAmmo",
                        args = {c._ammotype, c._ammo[c._ammotype]}
                    })
                    Citizen.Wait(1250)
                end
            end
        end
    end
end)

-- Disable Pistol Butting?
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        Citizen.Wait(0)
        if IsPedArmed(ped, 4 | 2) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        Citizen.Wait(0)
        if IsPedArmed(ped, 4 | 2) then
            if c._weapon ~= nil then
                TriggerServerCallback({
                    eventName = "UpdateAmmo",
                    args = {c._ammotype, c._ammo[c._ammotype]}
                })
                Citizen.Wait(2500)
            end
        end
    end
end)