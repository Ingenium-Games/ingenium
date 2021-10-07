-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    - Updated to PMC callbacks v2, with alerations to ensure it works?
]]--
math.randomseed(c.Seed)
-- ====================================================================================--

local DataPacket = RegisterClientCallback({
    eventName = 'DataPacket',
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
    eventName = 'GetVehicleCondition',
    eventCallback = function(net)
        local entity = NetToVeh(net)
        return c.GetVehicleCondition(entity)
    end
})

local SetVehicleCondition = RegisterClientCallback({
    eventName = 'SetVehicleCondition',
    eventCallback = function(net, con)
        local entity = NetToVeh(net)
        c.SetVehicleCondition(entity, con)
        return true
    end
})

local GetVehicleModifications = RegisterClientCallback({
    eventName = 'GetVehicleModifications',
    eventCallback = function(net)
        local entity = NetToVeh(net)
        return c.GetVehicleModifications(entity)
    end
})

local SetVehicleModifications = RegisterClientCallback({
    eventName = 'SetVehicleModifications',
    eventCallback = function(net, mods) 
        local entity = NetToVeh(net)
        c.SetVehicleModifications(entity, mods)
        return true
    end
})
