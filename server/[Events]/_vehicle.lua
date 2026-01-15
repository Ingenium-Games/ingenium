-- ====================================================================================--
-- Server-Side Vehicle Event Handlers
-- Migrated from ig.base
-- ====================================================================================--

--- Player entered vehicle event
---@param netId number Network ID of the vehicle
---@param seat number Seat index (-1 = driver)
---@param vehicleName string Display name of vehicle
RegisterNetEvent("Server:Vehicle:PlayerEntered", function(netId, seat, vehicleName)
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
        
        ig.log.Trace("Vehicle", "Player " .. source .. " entered vehicle: " .. vehicleName .. " (seat " .. seat .. ")")
        
        -- Trigger any server-side vehicle entry logic
        TriggerEvent("Server:Vehicle:OnPlayerEntered", source, vehicle, seat, netId)
    end
end)

--- Player left vehicle event
---@param netId number Network ID of the vehicle
---@param seat number Seat index (-1 = driver)
---@param vehicleName string Display name of vehicle
RegisterNetEvent("Server:Vehicle:PlayerLeft", function(netId, seat, vehicleName)
    local source = source
    local player = Player(source)
    
    if not player then return end
    
    -- Update player state
    player.state:set("InVehicle", false, true)
    player.state:set("VehicleSeat", -1, true)
    player.state:set("Vehicle", 0, true)
    
    ig.log.Trace("Vehicle", "Player " .. source .. " left vehicle: " .. vehicleName)
    
    -- Trigger any server-side vehicle exit logic
    TriggerEvent("Server:Vehicle:OnPlayerLeft", source, netId, seat)
end)

-- ====================================================================================--
-- Vehicle Persistence Event Handlers
-- ====================================================================================--

--- Register vehicle condition when player enters (client sends identifiers only)
---@param netId number Network ID of the vehicle
---@param plate string Vehicle plate
---@param condition table Vehicle condition data (client visual state)
---@param modifications table Vehicle modifications (client visual state)
RegisterNetEvent("Server:VehiclePersistence:RegisterCondition", function(netId, plate, condition, modifications)
        -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= conf.resourcename then
        CancelEvent()
        return
    end
    --
    local source = source
    
    if not plate or plate == "" then
        ig.log.Warn("Invalid plate received from client: " .. source)
        return
    end
    
    -- Get vehicle entity from network ID to read statebag directly (don't trust client)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    local statebag = {}
    
    if vehicle and DoesEntityExist(vehicle) then
        -- Read statebag directly from server vehicle entity (authoritative)
        statebag = ig.func.GetVehicleStatebag(vehicle)
    end
    
    -- Update persistence system with condition and server-read statebag (not client-provided)
    if ig.vehicle and ig.vehicle.UpdateVehicleState then
        ig.vehicle.UpdateVehicleState(plate, condition, modifications, statebag)
    end
    
    if conf.persistence and conf.persistence.logging and conf.persistence.logging.enabled then
        ig.log.Debug("VEHICLE", "Vehicle condition registered: " .. plate .. " from player " .. source)
    end
end)

--- Update vehicle condition when player exits (client sends identifiers only)
---@param netId number Network ID of the vehicle
---@param plate string Vehicle plate
---@param condition table Vehicle condition data (client visual state)
---@param modifications table Vehicle modifications (client visual state)
---@param coords table Vehicle coordinates
---@param fuel number Fuel level
RegisterNetEvent("Server:VehiclePersistence:UpdateCondition", function(netId, plate, condition, modifications, coords, fuel)
        -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= conf.resourcename then
        CancelEvent()
        return
    end
    --
    local source = source
    
    if not plate or plate == "" then
        ig.log.Warn("Invalid plate received from client: " .. source)
        return
    end
    
    -- Get vehicle entity from network ID to read statebag directly (don't trust client)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    local statebag = {}
    
    if vehicle and DoesEntityExist(vehicle) then
        -- Read statebag directly from server vehicle entity (authoritative)
        statebag = ig.func.GetVehicleStatebag(vehicle)
    end
    
    -- Update persistence system with final condition and server-read statebag (not client-provided)
    if ig.vehicle then
        ig.vehicle.UpdateVehicleState(plate, condition, modifications, statebag)
        ig.vehicle.UpdateVehicleLocation(plate, coords, 0, fuel)
    end
    
    if conf.persistence and conf.persistence.logging and conf.persistence.logging.enabled then
        ig.log.Debug("VEHICLE", "Vehicle condition updated on exit: " .. plate .. " from player " .. source)
    end
end)

