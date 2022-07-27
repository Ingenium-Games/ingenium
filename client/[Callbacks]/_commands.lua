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
