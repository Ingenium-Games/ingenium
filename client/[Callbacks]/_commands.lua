-- ====================================================================================--

-- ====================================================================================--
local TeleportOnMarker = RegisterClientCallback({
    eventName = "TeleportOnMarker",
    eventCallback = function()
        local wp = GetFirstBlipInfoId(8)
        if DoesBlipExist(wp) then
            ig.funig.FadeOut(1000)
            local ords = GetBlipInfoIdCoord(wp)
            for height = 0.1, 1000.0, 1.0 do
                SetPedCoordsKeepVehicle(PlayerPedId(), ords["x"], ords["y"], height + 0.0)
                local found, z = GetGroundZFor_3dCoord(ords["x"], ords["y"], height + 0.0)
                if found then
                    SetPedCoordsKeepVehicle(PlayerPedId(), ords["x"], ords["y"], height + 0.0)
                    break
                end
                Citizen.Wait(0)
            end
            ig.funig.FadeIn(1000)
        end
    end
})

local Teleport = RegisterClientCallback({
    eventName = "Teleport",
    eventCallback = function(ords)
        ig.funig.FadeOut(1000)
        SetEntityCoords(PlayerPedId(), ords["x"], ords["y"], ords["z"])
        SetEntityHeading(PlayerPedId(), ords["h"])
        ig.funig.FadeIn(1000)
    end
})

local Revive = RegisterClientCallback({
    eventName = "Revive",
    eventCallback = function(ords)
        ig.funig.FadeOut(1000)
        NetworkResurrectLocalPlayer(ords.x, ords.y, ords.z, ords.h, true, false)
        ig.status.SetHealth(150)
        ig.data.SetLocalPlayerState("IsDead", false, true)
        ig.funig.FadeIn(1000)
    end
})

local Heal = RegisterClientCallback({
    eventName = "Heal",
    eventCallback = function()
        ClearPedBloodDamage(PlayerPedId())
        ig.status.SetHealth(ig.status.GetMaxHealth())
    end
})

