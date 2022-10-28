local TeleportOnMarker = RegisterClientCallback({
    eventName = "TeleportOnMarker",
    eventCallback = function()
        local wp = GetFirstBlipInfoId(8)
        if DoesBlipExist(wp) then
            c.func.FadeOut(1000)
            local ords = GetBlipInfoIdCoord(wp)
            for height = 1, 1000 do
                SetPedCoordsKeepVehicle(PlayerPedId(), ords["x"], ords["y"], height + 0.0)
                local found, z = GetGroundZFor_3dCoord(ords["x"], ords["y"], height + 0.0)
                if found then
                    SetPedCoordsKeepVehicle(PlayerPedId(), ords["x"], ords["y"], height + 0.0)
                    break
                end
                Citizen.Wait(1)
            end
            c.func.FadeIn(1000)
        end
    end
})

local Teleport = RegisterClientCallback({
    eventName = "Teleport",
    eventCallback = function(ords)
        c.func.FadeOut(1000)
        SetEntityCoords(PlayerPedId(), ords["x"], ords["y"], ords["z"])
        SetEntityHeading(PlayerPedId(), ords["h"])
        c.func.FadeIn(1000)
    end
})

local Revive = RegisterClientCallback({
    eventName = "Revive",
    eventCallback = function(ords)
        c.func.FadeOut(1000)
        NetworkResurrectLocalPlayer(ords.x, ords.y, ords.z, ords.h, true, false)
        c.status.SetHealth(150)
        c.data.SetLocalPlayerState("IsDead", false, true)
        c.func.FadeIn(1000)
    end
})

local Heal = RegisterClientCallback({
    eventName = "Heal",
    eventCallback = function()
        ClearPedBloodDamage(PlayerPedId())
        c.status.SetHealth(c.status.GetMaxHealth())
    end
})

