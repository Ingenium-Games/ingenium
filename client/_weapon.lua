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
                print("shooting")
                --TriggerServerEvent("Server:Character:UpdateAmmo", )
            end
        end
    end
end)
