-- ====================================================================================--
-- Client-side Job Vehicle Spawn Handler
-- ====================================================================================--
-- Handles the client-side spawning of job vehicles when authorized by the server.
--
-- Integration:
-- - Listens for 'ingenium:clientSpawnVehicle' event from server
-- - Spawns vehicle at specified coordinates or at nearest parking spot
-- - Uses existing garage system spawn logic for consistency
--
-- This file is automatically loaded via the client_scripts wildcard in fxmanifest.lua
-- ====================================================================================--

-- Listen for server-authorized spawn requests
RegisterNetEvent('ingenium:clientSpawnVehicle', function(data)
    if type(data) ~= 'table' or not data.model then
        print('[ingenium|job-vehicles] Invalid spawn data received')
        return
    end
    
    local model = data.model
    local coords = data.coords
    local isJobVehicle = data.jobVehicle or false
    
    -- Determine spawn location
    local spawnCoords = nil
    
    if coords and type(coords) == 'table' and coords.x and coords.y and coords.z then
        -- Use provided coordinates
        spawnCoords = coords
    else
        -- Find nearest parking spot to player
        local playerPos = GetEntityCoords(PlayerPedId())
        local bestSpot = nil
        local bestDistance = math.huge
        
        if conf and conf.garage and conf.garage.parkingspots then
            for _, spot in ipairs(conf.garage.parkingspots) do
                -- Check if spot is clear (using existing function if available)
                local isClear = true
                if c and c.func and c.func.IsVehicleSpawnClear then
                    isClear = c.func.IsVehicleSpawnClear(spot, 1.2)
                else
                    -- Fallback: simple check for nearby vehicles
                    local nearbyVeh = GetClosestVehicle(spot.x, spot.y, spot.z, 2.0, 0, 70)
                    isClear = (nearbyVeh == 0)
                end
                
                if isClear then
                    local distance = #(vector3(spot.x, spot.y, spot.z) - playerPos)
                    if distance < bestDistance then
                        bestDistance = distance
                        bestSpot = spot
                    end
                end
            end
        end
        
        if bestSpot then
            spawnCoords = bestSpot
        else
            TriggerEvent("Client:Notify", "No available parking spots nearby.", 2)
            return
        end
    end
    
    -- Load vehicle model
    local modelHash = GetHashKey(model)
    
    if not IsModelInCdimage(modelHash) or not IsModelAVehicle(modelHash) then
        print(('[ingenium|job-vehicles] Invalid vehicle model: %s'):format(model))
        TriggerEvent("Client:Notify", "Invalid vehicle model.", 2)
        return
    end
    
    RequestModel(modelHash)
    
    local timeout = 0
    while not HasModelLoaded(modelHash) do
        Citizen.Wait(50)
        timeout = timeout + 50
        if timeout > 10000 then
            print(('[ingenium|job-vehicles] Timeout loading model: %s'):format(model))
            TriggerEvent("Client:Notify", "Failed to load vehicle.", 2)
            return
        end
    end
    
    -- Create the vehicle
    local vehicle = CreateVehicle(
        modelHash,
        spawnCoords.x,
        spawnCoords.y,
        spawnCoords.z,
        spawnCoords.h or 0.0,
        true,
        false
    )
    
    if not DoesEntityExist(vehicle) then
        print('[ingenium|job-vehicles] Failed to create vehicle entity')
        TriggerEvent("Client:Notify", "Failed to spawn vehicle.", 2)
        SetModelAsNoLongerNeeded(modelHash)
        return
    end
    
    -- Set vehicle properties
    SetVehicleOnGroundProperly(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehRadioStation(vehicle, "OFF")
    
    -- Set as network entity if in multiplayer
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    SetNetworkIdExistsOnAllMachines(netId, true)
    
    -- Put player in vehicle if configured
    if conf and conf.garage and conf.garage.retrieval and conf.garage.retrieval.spawn_in_vehicle then
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end
    
    -- Set fuel if configured (requires a fuel system)
    if conf and conf.garage and conf.garage.retrieval and conf.garage.retrieval.fuel_on_spawn then
        local fuelLevel = conf.garage.retrieval.fuel_on_spawn
        -- Try common fuel exports
        if GetResourceState("LegacyFuel") == "started" then
            exports["LegacyFuel"]:SetFuel(vehicle, fuelLevel)
        elseif GetResourceState("okokGasStation") == "started" then
            exports["okokGasStation"]:SetFuel(vehicle, fuelLevel)
        elseif Entity(vehicle).state then
            -- Use state bags if available
            Entity(vehicle).state.fuel = fuelLevel
        end
    end
    
    -- Clean up
    SetModelAsNoLongerNeeded(modelHash)
    
    -- Notify player
    if isJobVehicle then
        TriggerEvent("Client:Notify", "Job vehicle spawned successfully.", 1)
    else
        TriggerEvent("Client:Notify", "Vehicle spawned successfully.", 1)
    end
end)

-- ====================================================================================--
