-- ====================================================================================--
-- Vehicle Event Integration with Persistence System
-- Sends initial condition/modifications to server when player enters vehicle
-- ====================================================================================--

--- Handle vehicle entry - capture and send condition to server
AddEventHandler("Client:EnteredVehicle", function(vehicle, seat, name, net)
    if not DoesEntityExist(vehicle) then return end
    
    local plate = GetVehicleNumberPlateText(vehicle)
    
    if not plate or plate == "" then return end
    
    -- Capture only client-side visible state (condition & mods are visual damage states)
    -- Server will read statebag directly from vehicle entity (don't trust client)
    local condition = ig.func.GetVehicleCondition(vehicle)
    local modifications = ig.func.GetVehicleModifications(vehicle)
    
    -- Send identifiers and visual state only - server handles statebag
    TriggerServerEvent("Server:VehiclePersistence:RegisterCondition", net, plate, condition, modifications)
end)

--- Handle vehicle exit - capture final condition state
AddEventHandler("Client:LeftVehicle", function(vehicle, seat, name, net)
    if not DoesEntityExist(vehicle) then return end
    
    local plate = GetVehicleNumberPlateText(vehicle)
    
    if not plate or plate == "" then return end
    
    -- Capture visual state only (client-side visible damage/condition)
    -- Server will read statebag directly from vehicle entity (don't trust client)
    local condition = ig.func.GetVehicleCondition(vehicle)
    local modifications = ig.func.GetVehicleModifications(vehicle)
    local coords = GetEntityCoords(vehicle)
    local heading = GetEntityHeading(vehicle)
    local fuel = GetVehicleFuelLevel(vehicle)
    
    -- Send identifiers and visual state only - server handles statebag
    TriggerServerEvent("Server:VehiclePersistence:UpdateCondition", net, plate, condition, modifications, {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        h = heading
    }, fuel)
end)
