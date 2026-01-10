-- ====================================================================================--
-- Job Vehicles - Client Side Handler
-- Handles client-side logic for job vehicle system
-- ====================================================================================--

if not ig.garage then ig.garage = {} end
ig.garage.jobVehicles = {}

-- ====================================================================================--
-- NUI Callback Handlers
-- ====================================================================================--

-- Handle spawn request from NUI
RegisterNUICallback("jobVehicles:spawn", function(data, cb)
    local vehicleModel = data.model
    local vehicleName = data.name or vehicleModel
    
    if not vehicleModel then
        cb("ok")
        return
    end
    
    -- Check if player is near a parking machine (reuse existing garage logic)
    if not ig.garage._MachinePosition then
        TriggerEvent("Client:Notify", "You must be at a parking machine to spawn vehicles", 2)
        cb("ok")
        return
    end
    
    -- Find available parking spot
    local Position = ig.garage._MachinePosition
    local bestSpot = nil
    local bestDistance = math.huge
    
    for _, spot in ipairs(conf.garage.parkingspots) do
        if c.func.IsVehicleSpawnClear(spot, 1.2) then
            local distance = #(vector3(spot.x, spot.y, spot.z) - Position)
            if distance < bestDistance then
                bestDistance = distance
                bestSpot = spot
            end
        end
    end
    
    if not bestSpot then
        TriggerEvent("Client:Notify", "No available parking spots nearby", 2)
        cb("ok")
        return
    end
    
    -- Request server to spawn the vehicle
    local success, result = ig.callback.Await("ingenium:SpawnJobVehicle", vehicleModel, bestSpot)
    
    if not success then
        -- Server will have already sent appropriate notification
        ig.func.Debug_1("[Job Vehicles] Failed to spawn vehicle: " .. tostring(result))
    else
        ig.func.Debug_1("[Job Vehicles] Successfully spawned vehicle with net ID: " .. tostring(result))
    end
    
    cb("ok")
end)

-- ====================================================================================--
-- Event Handler: Show job vehicles when garage opens
-- ====================================================================================--

AddEventHandler("Client:Interact:ParkingMachine", function(data)
    -- This event fires when garage is opened
    -- We'll piggyback on it to also load job vehicles
    Citizen.CreateThread(function()
        -- Wait a moment for the garage to fully open
        Citizen.Wait(100)
        
        -- Request and display job vehicles
        local jobVehicles = ig.callback.Await("ingenium:GetJobVehicles")
        local playerJob = ig.callback.Await("GetPlayerJob")
        local jobName = playerJob and playerJob.job or ""
        
        SendNUIMessage({
            message = "jobVehicles:show",
            data = {
                vehicles = jobVehicles or {},
                job = jobName
            }
        })
    end)
end)

-- ====================================================================================--
ig.func.Debug_1("[Job Vehicles] Client initialized")
-- ====================================================================================--
