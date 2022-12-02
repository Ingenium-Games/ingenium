-- ====================================================================================--

-- ====================================================================================--
-- [C]
AddEventHandler("Client:EnteredVehicle", function(vehicle, seat, name, net)
    local condition = c.func.GetVehicleCondition(vehicle)
    local modifictions = c.func.GetVehicleModifications(vehicle)
    TriggerServerCallback({
        eventName = "SetVehicleConMods",
        args = {net, condition, modifictions}
    })
end)
-- [C]
AddEventHandler("Client:LeftVehicle", function(vehicle, seat, name, net)
    local condition = c.func.GetVehicleCondition(vehicle)
    local modifictions = c.func.GetVehicleModifications(vehicle)
    TriggerServerCallback({
        eventName = "SetVehicleConMods",
        args = {net, condition, modifictions}
    })
end)
