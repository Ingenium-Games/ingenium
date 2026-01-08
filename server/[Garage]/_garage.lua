-- ====================================================================================--
-- ig.garage - Advanced Vehicle Parking System
-- ====================================================================================--
if not ig.garage then
    ig.garage = {}
end
-- ====================================================================================--

-- Store spawned parking machine props
local parkingMachines = {}

-- Store occupied parking spots
local occupiedSpots = {}

-- ====================================================================================--
-- Initialization
-- ====================================================================================--

--- Initialize garage system on server start
function ig.garage.Initialize()
    ig.func.Debug_1("Initializing ig.garage system...")
    
    -- Spawn parking machine props at each garage location
    for garageId, garageData in pairs(conf.garage.locations) do
        ig.garage.SpawnParkingMachine(garageId, garageData)
    end
    
    -- Initialize occupied spots tracking
    ig.garage.InitializeOccupiedSpots()
    
    ig.func.Debug_1("ig.garage system initialized successfully")
end

--- Spawn parking machine prop at garage location
---@param garageId string Garage identifier
---@param garageData table Garage configuration data
function ig.garage.SpawnParkingMachine(garageId, garageData)
    if not garageData.Machine then return end
    
    local machine = garageData.Machine
    local coords = machine.Coords
    
    -- Create the prop entity
    local prop = CreateObject(
        GetHashKey(machine.Model),
        coords.x,
        coords.y,
        coords.z,
        true,
        true,
        false
    )
    
    if DoesEntityExist(prop) then
        SetEntityHeading(prop, coords.h)
        FreezeEntityPosition(prop, true)
        parkingMachines[garageId] = prop
        ig.func.Debug_2("Spawned parking machine for garage: " .. garageId)
    else
        ig.func.Debug_1("Failed to spawn parking machine for garage: " .. garageId)
    end
end

--- Initialize tracking of occupied parking spots
function ig.garage.InitializeOccupiedSpots()
    for garageId, garageData in pairs(conf.garage.locations) do
        occupiedSpots[garageId] = {}
        for spotIndex, spot in ipairs(garageData.Spots) do
            occupiedSpots[garageId][spotIndex] = false
        end
    end
end

-- ====================================================================================--
-- Parking Spot Management
-- ====================================================================================--

--- Check if a parking spot is occupied
---@param garageId string Garage identifier
---@param spotIndex number Spot index
---@return boolean occupied True if spot is occupied
function ig.garage.IsSpotOccupied(garageId, spotIndex)
    local spot = conf.garage.locations[garageId].Spots[spotIndex]
    if not spot then return true end
    
    local coords = vector3(spot.x, spot.y, spot.z)
    local radius = conf.garage.settings.OccupancyCheckRadius
    
    -- Check for vehicles at the spot location
    local vehicles = GetAllVehicles()
    for _, vehicle in ipairs(vehicles) do
        if DoesEntityExist(vehicle) then
            local vehCoords = GetEntityCoords(vehicle)
            local distance = #(coords - vehCoords)
            if distance < radius then
                occupiedSpots[garageId][spotIndex] = true
                return true
            end
        end
    end
    
    -- Check for objects at the spot location
    local objects = GetAllObjects()
    for _, object in ipairs(objects) do
        if DoesEntityExist(object) then
            local objCoords = GetEntityCoords(object)
            local distance = #(coords - objCoords)
            if distance < radius then
                occupiedSpots[garageId][spotIndex] = true
                return true
            end
        end
    end
    
    occupiedSpots[garageId][spotIndex] = false
    return false
end

--- Find the nearest available parking spot
---@param garageId string Garage identifier
---@param playerCoords vector3 Player coordinates for distance calculation
---@return table|nil spot Nearest available spot or nil if none available
---@return number|nil spotIndex Index of the spot
function ig.garage.FindNearestAvailableSpot(garageId, playerCoords)
    local garageData = conf.garage.locations[garageId]
    if not garageData then return nil, nil end
    
    local nearestSpot = nil
    local nearestDistance = math.huge
    local nearestIndex = nil
    
    for spotIndex, spot in ipairs(garageData.Spots) do
        if not ig.garage.IsSpotOccupied(garageId, spotIndex) then
            local spotCoords = vector3(spot.x, spot.y, spot.z)
            local distance = #(playerCoords - spotCoords)
            
            if distance < nearestDistance then
                nearestDistance = distance
                nearestSpot = spot
                nearestIndex = spotIndex
            end
        end
    end
    
    return nearestSpot, nearestIndex
end

--- Get all available parking spots for a garage
---@param garageId string Garage identifier
---@return table availableSpots Array of available spot indices
function ig.garage.GetAvailableSpots(garageId)
    local available = {}
    local garageData = conf.garage.locations[garageId]
    
    if not garageData then return available end
    
    for spotIndex, spot in ipairs(garageData.Spots) do
        if not ig.garage.IsSpotOccupied(garageId, spotIndex) then
            table.insert(available, spotIndex)
        end
    end
    
    return available
end

-- ====================================================================================--
-- Vehicle Spawning
-- ====================================================================================--

--- Spawn a vehicle at a parking spot
---@param vehicleData table Vehicle data from database
---@param garageId string Garage identifier
---@param spotCoords table Spot coordinates {x, y, z, h}
---@return number|nil netId Network ID of spawned vehicle
function ig.garage.SpawnVehicle(vehicleData, garageId, spotCoords)
    if not vehicleData or not spotCoords then return nil end
    
    local model = vehicleData.Model
    local modelHash = GetHashKey(model)
    
    -- Create the vehicle
    local vehicle = CreateVehicle(
        modelHash,
        spotCoords.x,
        spotCoords.y,
        spotCoords.z,
        spotCoords.h,
        true,
        true
    )
    
    if not DoesEntityExist(vehicle) then
        ig.func.Debug_1("Failed to spawn vehicle: " .. model)
        return nil
    end
    
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    
    -- Create xVehicle instance
    ig.vehicle.AddVehicle(netId, ig.class.OwnedVehicle, netId, vehicleData)
    local xVehicle = ig.vehicle.GetVehicle(netId)
    
    if xVehicle then
        -- Set vehicle properties
        xVehicle.SetParked(false)
        xVehicle.SetGarage(garageId)
        
        -- Set plate
        SetVehicleNumberPlateText(vehicle, vehicleData.Plate)
        
        ig.func.Debug_2("Spawned vehicle " .. vehicleData.Plate .. " at garage: " .. garageId)
    end
    
    return netId
end

--- Retrieve a player's vehicle from garage
---@param source number Player source
---@param plate string Vehicle plate
---@param garageId string Garage identifier
---@return boolean success True if vehicle was retrieved successfully
function ig.garage.RetrieveVehicle(source, plate, garageId)
    local xPlayer = ig.data.GetPlayer(source)
    if not xPlayer then return false end
    
    -- Get vehicle data from database
    local vehicleData = ig.sql.veh.GetByPlate(plate)
    if not vehicleData then
        TriggerClientEvent('Client:Notify', source, "Vehicle not found in database")
        return false
    end
    
    -- Check if vehicle is parked
    if vehicleData.Parked ~= 1 then
        TriggerClientEvent('Client:Notify', source, "Vehicle is already out")
        return false
    end
    
    -- Check ownership
    if vehicleData.Character_ID ~= xPlayer.GetCharacter_ID() then
        TriggerClientEvent('Client:Notify', source, "You don't own this vehicle")
        return false
    end
    
    -- Find nearest available spot
    local playerCoords = xPlayer.GetCoords()
    local coords = vector3(playerCoords.x, playerCoords.y, playerCoords.z)
    local spot, spotIndex = ig.garage.FindNearestAvailableSpot(garageId, coords)
    
    if not spot then
        TriggerClientEvent('Client:Notify', source, "No available parking spots")
        return false
    end
    
    -- Spawn the vehicle
    local netId = ig.garage.SpawnVehicle(vehicleData, garageId, spot)
    
    if netId then
        TriggerClientEvent('Client:Notify', source, "Vehicle retrieved: " .. plate)
        return true
    else
        TriggerClientEvent('Client:Notify', source, "Failed to spawn vehicle")
        return false
    end
end

--- Store a vehicle in garage
---@param source number Player source
---@param netId number Vehicle network ID
---@param garageId string Garage identifier
---@return boolean success True if vehicle was stored successfully
function ig.garage.StoreVehicle(source, netId, garageId)
    local xPlayer = ig.data.GetPlayer(source)
    if not xPlayer then return false end
    
    local xVehicle = ig.vehicle.GetVehicle(netId)
    if not xVehicle then
        TriggerClientEvent('Client:Notify', source, "Vehicle not found")
        return false
    end
    
    -- Check ownership
    if xVehicle.GetOwner() ~= xPlayer.GetCharacter_ID() then
        TriggerClientEvent('Client:Notify', source, "You don't own this vehicle")
        return false
    end
    
    -- Mark vehicle as parked
    xVehicle.SetParked(true)
    xVehicle.SetGarage(garageId)
    
    -- Delete the vehicle entity
    local entity = xVehicle.GetEntity()
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end
    
    -- Remove from vehicle index
    ig.vehicle.RemoveVehicle(netId)
    
    TriggerClientEvent('Client:Notify', source, "Vehicle stored in garage")
    ig.func.Debug_2("Stored vehicle " .. xVehicle.GetPlate() .. " in garage: " .. garageId)
    
    return true
end

-- ====================================================================================--
-- Vehicle Auto-Save on Exit
-- ====================================================================================--

--- Hook into player left vehicle event for auto-save
AddEventHandler("Server:OnPlayerLeftVehicle", function(source, netId, seat)
    -- Only save when exiting driver seat
    if seat ~= -1 then return end
    
    -- Check if auto-save is enabled
    if not conf.garage.settings.AutoSaveOnExit then return end
    
    local xVehicle = ig.vehicle.GetVehicle(netId)
    if not xVehicle then return end
    
    -- Mark vehicle as dirty to trigger save
    xVehicle.SetUpdated()
    
    ig.func.Debug_3("Auto-save triggered for vehicle on driver exit: " .. xVehicle.GetPlate())
end)

-- ====================================================================================--
-- Server Events
-- ====================================================================================--

--- Event: Retrieve vehicle from garage
RegisterNetEvent("Server:Garage:RetrieveVehicle", function(plate, garageId)
    local source = source
    ig.garage.RetrieveVehicle(source, plate, garageId)
end)

--- Event: Store vehicle in garage
RegisterNetEvent("Server:Garage:StoreVehicle", function(netId, garageId)
    local source = source
    ig.garage.StoreVehicle(source, netId, garageId)
end)

-- ====================================================================================--
-- Initialize on resource start
-- ====================================================================================--
CreateThread(function()
    Wait(1000) -- Wait for other systems to initialize
    ig.garage.Initialize()
end)
