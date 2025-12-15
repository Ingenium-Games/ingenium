-- ====================================================================================--
-- Server-Side Vehicle Event Handlers
-- Migrated from ig.base
-- ====================================================================================--

--- Player entered vehicle event
---@param netId number Network ID of the vehicle
---@param seat number Seat index (-1 = driver)
---@param vehicleName string Display name of vehicle
RegisterNetEvent("Server:PlayerEnteredVehicle", function(netId, seat, vehicleName)
    local source = source
    local player = Player(source)
    
    if not player then return end
    
    -- Get vehicle entity from network ID
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    
    if vehicle and DoesEntityExist(vehicle) then
        -- Update player state
        player.state:set("InVehicle", true, true)
        player.state:set("VehicleSeat", seat, true)
        player.state:set("Vehicle", netId, true)
        
        c.func.Debug_3("Player " .. source .. " entered vehicle: " .. vehicleName .. " (seat " .. seat .. ")")
        
        -- Trigger any server-side vehicle entry logic
        TriggerEvent("Server:OnPlayerEnteredVehicle", source, vehicle, seat, netId)
    end
end)

--- Player left vehicle event
---@param netId number Network ID of the vehicle
---@param seat number Seat index (-1 = driver)
---@param vehicleName string Display name of vehicle
RegisterNetEvent("Server:PlayerLeftVehicle", function(netId, seat, vehicleName)
    local source = source
    local player = Player(source)
    
    if not player then return end
    
    -- Update player state
    player.state:set("InVehicle", false, true)
    player.state:set("VehicleSeat", -1, true)
    player.state:set("Vehicle", 0, true)
    
    c.func.Debug_3("Player " .. source .. " left vehicle: " .. vehicleName)
    
    -- Trigger any server-side vehicle exit logic
    TriggerEvent("Server:OnPlayerLeftVehicle", source, netId, seat)
end)
