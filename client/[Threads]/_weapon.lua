
-- Modify ammo counts and trigger ammo updates to server.
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        Citizen.Wait(0)
        if IsPedArmed(ped, 4 | 2) then
            if IsPedShooting(ped) then
                Citizen.Wait(100)
                if c._weapon ~= nil and c._ammotype ~= nil then
                    c._ammo[c._ammotype] = c._ammo[c._ammotype] - 1
                end
            end
            if IsPedReloading(ped) then
                if c._weapon ~= nil then
                    TriggerServerCallback({
                        eventName = "UpdateAmmo",
                        args = {c._ammotype, c._ammo[c._ammotype]}
                    })
                end
            end
        end
    end
end)

-- Disable Pistol Butting
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

-- Update the server x time when shooting
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        Citizen.Wait(0)
        if IsPedArmed(ped, 4 | 2) then
            if IsPedShooting(ped) then
                TriggerServerCallback({
                    eventName = "UpdateAmmo",
                    args = {c._ammotype, c._ammo[c._ammotype]}
                })
            end
            Citizen.Wait(375)
        end
    end
end)

-- Update the server x time when shooting
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        Citizen.Wait(10000)
        if IsPedArmed(ped, 4 | 2) then
            print(c._ammotype,c._weapon)
        end
    end
end)