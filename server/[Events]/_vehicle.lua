-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--

-- ====================================================================================--
-- [C+S]
RegisterNetEvent("Server:Vehicle:Create")
AddEventHandler("Server:Vehicle:Create", function(net, plate, stolen)
    local src = source
    if not stolen then stolen = false end
    if plate then
        c.data.AddVehicle(net, c.class.CreatePlayerVehicle, plate, stolen)
    else
        c.data.AddVehicle(net, c.class.CreateVehicle, net, stolen)
    end
end)
