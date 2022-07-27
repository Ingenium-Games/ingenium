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
