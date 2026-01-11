-- ====================================================================================--
-- Job Vehicle Spawning - Client-Side Implementation
-- ====================================================================================--

if not ig then ig = {} end
if not ig.job_vehicles then ig.job_vehicles = {} end

-- Internal state
ig.job_vehicles._spawners = {}
ig.job_vehicles._props = {}

--- Initialize job vehicle spawners
function ig.job_vehicles.Init()
    if not conf.job_vehicles.enabled then
        return
    end
    
    -- Create props and targets for each spawner
    for i, spawner in ipairs(conf.job_vehicles.spawners) do
        ig.job_vehicles.CreateSpawner(i, spawner)
    end
    
    ig.func.Debug_2("Job vehicle spawners initialized: " .. #conf.job_vehicles.spawners)
end

--- Create a single spawner prop and target
---@param id number Spawner ID
---@param spawner table Spawner configuration
function ig.job_vehicles.CreateSpawner(id, spawner)
    local prop = spawner.prop
    local model = conf.job_vehicles.spawner_prop
    
    -- Create prop
    local hash = type(model) == "number" and model or GetHashKey(model)
    RequestModel(hash)
    
    while not HasModelLoaded(hash) do
        Citizen.Wait(10)
    end
    
    local propEntity = CreateObject(hash, prop.x, prop.y, prop.z, false, false, false)
    SetEntityHeading(propEntity, prop.h)
    FreezeEntityPosition(propEntity, true)
    SetEntityAsMissionEntity(propEntity, true, true)
    
    -- Store prop reference
    ig.job_vehicles._props[id] = propEntity
    
    -- Add target interaction
    exports['ingenium']:AddLocalEntity(propEntity, {
        {
            name = "job_vehicle_spawner_" .. id,
            icon = "fas fa-car",
            label = spawner.label or "Spawn Job Vehicle",
            canInteract = function()
                -- Check if player has correct job
                local playerData = LocalPlayer.state
                if not playerData.Job then return false end
                
                if playerData.Job ~= spawner.job then
                    return false
                end
                
                -- Check grade if required
                if spawner.grade and (playerData.Grade or 0) < spawner.grade then
                    return false
                end
                
                return true
            end,
            action = function()
                ig.job_vehicles.OpenMenu(id)
            end,
        }
    })
    
    ig.func.Debug_3("Job vehicle spawner created at: " .. prop.x .. ", " .. prop.y .. ", " .. prop.z)
end

--- Open vehicle selection menu
---@param spawnerId number Spawner ID
function ig.job_vehicles.OpenMenu(spawnerId)
    -- Get available vehicles from server
    TriggerServerCallback({
        eventName = "JobVehicles:GetVehicles",
        args = {spawnerId},
        callback = function(vehicles)
            if not vehicles then
                ig.func.Notify("~r~You are not authorized to use this spawner.", "error")
                return
            end
            
            -- Build menu options
            local elements = {}
            for i, vehicle in ipairs(vehicles) do
                table.insert(elements, {
                    label = vehicle.label or vehicle.model,
                    value = i,
                    description = "Spawn " .. (vehicle.label or vehicle.model)
                })
            end
            
            -- Show NUI menu
            SendNUIMessage({
                message = 'jobvehicles:open',
                data = {
                    title = "Job Vehicles",
                    spawnerId = spawnerId,
                    vehicles = elements
                }
            })
            SetNuiFocus(true, true)
        end
    })
end

--- Spawn selected vehicle
---@param spawnerId number Spawner ID
---@param vehicleIndex number Vehicle index
function ig.job_vehicles.SpawnVehicle(spawnerId, vehicleIndex)
    TriggerServerCallback({
        eventName = "JobVehicles:SpawnVehicle",
        args = {spawnerId, vehicleIndex},
        callback = function(netId)
            if not netId then
                ig.func.Notify("~r~Failed to spawn vehicle.", "error")
                return
            end
            
            -- Wait for vehicle to exist
            local timeout = GetGameTimer() + 3000
            local vehicle = nil
            
            while GetGameTimer() < timeout do
                vehicle = NetworkGetEntityFromNetworkId(netId)
                if DoesEntityExist(vehicle) then
                    break
                end
                Citizen.Wait(10)
            end
            
            if not DoesEntityExist(vehicle) then
                ig.func.Notify("~r~Vehicle spawn timed out.", "error")
                return
            end
            
            -- Put player in vehicle
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            
            ig.func.Notify("~g~Vehicle spawned successfully.", "success")
        end
    })
end

--- Close menu
function ig.job_vehicles.CloseMenu()
    SendNUIMessage({
        message = 'jobvehicles:close'
    })
    SetNuiFocus(false, false)
end

--- Cleanup spawner props
function ig.job_vehicles.Cleanup()
    for id, propEntity in pairs(ig.job_vehicles._props) do
        if DoesEntityExist(propEntity) then
            DeleteEntity(propEntity)
        end
    end
    
    ig.job_vehicles._props = {}
end

-- NUI Callbacks
RegisterNUICallback('JobVehicles:SelectVehicle', function(data, cb)
    ig.job_vehicles.CloseMenu()
    ig.job_vehicles.SpawnVehicle(data.spawnerId, data.vehicleIndex)
    cb('ok')
end)

RegisterNUICallback('JobVehicles:Close', function(data, cb)
    ig.job_vehicles.CloseMenu()
    cb('ok')
end)

-- Initialize on resource start
CreateThread(function()
    -- Wait for player to be loaded
    while not LocalPlayer.state.Character_ID do
        Citizen.Wait(100)
    end
    
    -- Wait a bit more for config to load
    Citizen.Wait(1000)
    
    -- Initialize spawners
    ig.job_vehicles.Init()
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    ig.job_vehicles.Cleanup()
end)

-- ====================================================================================--
