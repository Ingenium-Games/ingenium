-- ====================================================================================--
c.weapon = {}
-- ====================================================================================--

function c.weapon.Set(hash)
    if hash then
        c._weapon = tonumber(hash)
    else
        c._weapon = nil
    end
end

function c.weapon.Get()
    return c._weapon
end

function c.weapon.SetComponents(components)
    c._components = components
end

function c.weapon.GetComponents()
    return c._components
end

function c.weapon.GetName()
    return c._weaponname
end

--
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        Citizen.Wait(0)
        if IsPedArmed(ped, 4 | 2) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
            if IsPedShooting(ped) then
                Citizen.Wait(100)
                c._ammo[c._ammotype] = c._ammo[c._ammotype] - 1
            end
            if IsPedReloading(ped) then
                TriggerServerCallback({
                    eventName = "UpdateAmmo",
                    args = {c._ammotype, c._ammo[c._ammotype]}
                })
            end
        end
    end
end)
-- Update the server x time when shooting
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        Citizen.Wait(0)
        if IsPedShooting(ped) then
            Citizen.Wait(1250)
            TriggerServerCallback({
                eventName = "UpdateAmmo",
                args = {c._ammotype, c._ammo[c._ammotype]}
            })
        end
    end
end)