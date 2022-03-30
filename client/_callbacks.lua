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
            c.IsBusy()
            Citizen.Wait(500)
            data = c.data.Packet()
            Citizen.Wait(500)
            c.NotBusy()
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
            c.FadeOut(1000)
            local ords = GetBlipInfoIdCoord(wp)
            RequestAdditionalCollisionAtCoord(ords)
            local found, z = GetGroundZFor_3dCoord(ords["x"], ords["y"], ords["z"], true)
            while not found do
                Citizen.Wait(1)
            end
            SetPedCoordsKeepVehicle(PlayerPedId(), ords["x"], ords["y"], z)
            c.FadeIn(1000)
        end
    end
})

local Teleport = RegisterClientCallback({
    eventName = "Teleport",
    eventCallback = function(ords)
        c.FadeOut(1000)
        SetEntityCoords(PlayerPedId(), ords["x"], ords["y"], ords["z"])
        SetEntityHeading(PlayerPedId(), ords["h"])
        c.FadeIn(1000)
    end
})
