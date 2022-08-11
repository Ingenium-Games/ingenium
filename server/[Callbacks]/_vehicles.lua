local EnsurePlayerVehicle = RegisterServerCallback({
    eventName = "EnsurePlayerVehicle",
    eventCallback = function(source, net, plate)
        local entity = NetworkGetEntityFromNetworkId(net)
        local data = c.sql.veh.GetByPlate(plate)
        c.data.AddPlayerVehicle(plate, c.class.PlayerVehicle, entity, data)
    end
})