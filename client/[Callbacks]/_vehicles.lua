local GetVehicleCondition = RegisterClientCallback({
    eventName = "GetVehicleCondition",
    eventCallback = function(net)
        local entity = NetToVeh(net)
        return c.func.GetVehicleCondition(entity)
    end
})

local SetVehicleCondition = RegisterClientCallback({
    eventName = "SetVehicleCondition",
    eventCallback = function(net, con)
        if (c.func.WaitUntilNetIdExists(net, 30000)) then
            local entity = NetToVeh(net)
            c.func.SetVehicleCondition(entity, con)
            return true
        end
    end
})

local GetVehicleModifications = RegisterClientCallback({
    eventName = "GetVehicleModifications",
    eventCallback = function(net)
        local entity = NetToVeh(net)
        return c.func.GetVehicleModifications(entity)
    end
})

local SetVehicleModifications = RegisterClientCallback({
    eventName = "SetVehicleModifications",
    eventCallback = function(net, mods)
        if (c.func.WaitUntilNetIdExists(net, 30000)) then
            local entity = NetToVeh(net)
            c.func.SetVehicleModifications(entity, mods)
            return true
        end
    end
})
