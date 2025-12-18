-- ====================================================================================--

-- ====================================================================================--
-- [C]
AddEventHandler("Client:EnteredVehicle", function(vehicle, seat, name, net)
    local condition = ig.funig.GetVehicleCondition(vehicle)
    local modifictions = ig.funig.GetVehicleModifications(vehicle)
    TriggerServerCallback({
        eventName = "SetVehicleConMods",
        args = {net, condition, modifictions}
    })
end)
-- [C]
AddEventHandler("Client:LeftVehicle", function(vehicle, seat, name, net)
    local condition = ig.funig.GetVehicleCondition(vehicle)
    local modifictions = ig.funig.GetVehicleModifications(vehicle)
    TriggerServerCallback({
        eventName = "SetVehicleConMods",
        args = {net, condition, modifictions}
    })
end)
