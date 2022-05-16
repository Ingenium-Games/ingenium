-- ====================================================================================--


-- ====================================================================================--
-- [C+S]
RegisterNetEvent("Server:Vehicle:Create", function(net, plate)
    local src = source
    if plate then
        c.data.AddVehicle(net, c.class.Vehicle, net, plate)
    else
        c.data.AddVehicle(net, c.class.Vehicle, net)
    end
end)

local ClientCreateVehicle = RegisterServerCallback({
    eventName = "ClientCreateVehicle",
    eventCallback = function(source, net, data)
        c.data.RemoveVehicle(net)
        local ent = NetworkGetEntityFromNetworkId(net)
        c.data.SetVehicle(net, c.class.Vehicle, net, data)
        SetVehicleNumberPlateText(ent, data.Plate)
    end
})