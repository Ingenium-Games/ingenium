local AddVehicle = RegisterServerCallback({
    eventName = "AddVehicle",
    eventCallback = function(source, net)
        c.data.AddVehicle(net, c.class.Vehicle, net, false)
    end
})