-- ====================================================================================--


-- ====================================================================================--
-- [C+S]
RegisterNetEvent("Server:Vehicle:Create")
AddEventHandler("Server:Vehicle:Create", function(net, plate, stolen)
    local src = source
    local stolen = stolen or false
    if plate then
        c.data.AddVehicle(net, c.class.Vehicle.Respawn, plate, stolen)
    else
        c.data.AddVehicle(net, c.class.Vehicle.Generate, net, stolen)
    end
end)
