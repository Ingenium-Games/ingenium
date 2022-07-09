-- ====================================================================================--
--[[
NOTES.
    - Updated to PMC callbacks v2, with alerations to ensure it works?
]] --
-- ====================================================================================--
local DataPacket = RegisterClientCallback({
    eventName = "DataPacket",
    eventCallback = function()
        local data = false
        if c.data.GetLoadedStatus() then
            c.func.IsBusy()
            Citizen.Wait(500)
            data = c.data.Packet()
            Citizen.Wait(500)
            c.func.NotBusy()
        end
        return data
    end
})

local GetVehicleCondition = RegisterClientCallback({
    eventName = "GetVehicleCondition",
    eventCallback = function(net)
        local entity = NetToVeh(net)
        return c.GetVehicleCondition(entity)
    end
})

local SetVehicleCondition = RegisterClientCallback({
    eventName = "SetVehicleCondition",
    eventCallback = function(net, con)
        local entity = NetToVeh(net)
        c.SetVehicleCondition(entity, con)
        return true
    end
})

local GetVehicleModifications = RegisterClientCallback({
    eventName = "GetVehicleModifications",
    eventCallback = function(net)
        local entity = NetToVeh(net)
        return c.GetVehicleModifications(entity)
    end
})

local SetVehicleModifications = RegisterClientCallback({
    eventName = "SetVehicleModifications",
    eventCallback = function(net, mods)
        local entity = NetToVeh(net)
        c.SetVehicleModifications(entity, mods)
        return true
    end
})

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
