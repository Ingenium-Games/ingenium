-- ====================================================================================--

-- ====================================================================================--
-- [C]
AddEventHandler("Client:EnteredVehicle", function(vehicle, seat, name, net)
    local condition = ig.func.GetVehicleCondition(vehicle)
    local modifictions = ig.func.GetVehicleModifications(vehicle)
    TriggerServerCallback({
        eventName = "SetVehicleConMods",
        args = {net, condition, modifictions}
    })
end)
-- [C]
AddEventHandler("Client:LeftVehicle", function(vehicle, seat, name, net)
    local condition = ig.func.GetVehicleCondition(vehicle)
    local modifictions = ig.func.GetVehicleModifications(vehicle)
    TriggerServerCallback({
        eventName = "SetVehicleConMods",
        args = {net, condition, modifictions}
    })
end)
