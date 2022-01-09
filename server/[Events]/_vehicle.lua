-- ====================================================================================--


-- ====================================================================================--
-- [C+S]
RegisterNetEvent("Server:Vehicle:Create")
AddEventHandler("Server:Vehicle:Create", function(net, plate)
    local src = source
    if plate then
        c.data.AddVehicle(net, c.class.Vehicle, net, plate)
    else
        c.data.AddVehicle(net, c.class.Vehicle, net)
    end
end)
