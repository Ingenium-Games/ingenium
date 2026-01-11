-- ====================================================================================--
-- Job Vehicle Spawning - Server Callbacks
-- ====================================================================================--

if not ig then ig = {} end
if not ig.job_vehicles then ig.job_vehicles = {} end

--- Get available vehicles for player's job at spawner
---@param source number Player source
---@param spawnerId number Index of spawner in config
---@return table|boolean Available vehicles or false
local function GetAvailableVehicles(source, spawnerId)
    local xPlayer = ig.data.GetPlayer(source)
    if not xPlayer then return false end
    
    local spawner = conf.job_vehicles.spawners[spawnerId]
    if not spawner then return false end
    
    local playerJob = xPlayer.GetJob()
    
    -- Check job matches
    if playerJob.Name ~= spawner.job then
        return false
    end
    
    -- Check grade if specified
    if spawner.grade and playerJob.Grade < spawner.grade then
        return false
    end
    
    return spawner.vehicles
end

--- Callback to get vehicles for spawner
RegisterServerCallback({
    eventName = "JobVehicles:GetVehicles",
    eventCallback = function(source, spawnerId)
        if not conf.job_vehicles.enabled then
            return false
        end
        
        local vehicles = GetAvailableVehicles(source, spawnerId)
        return vehicles
    end
})

--- Callback to spawn job vehicle
RegisterServerCallback({
    eventName = "JobVehicles:SpawnVehicle",
    eventCallback = function(source, spawnerId, vehicleIndex)
        if not conf.job_vehicles.enabled then
            return false
        end
        
        local xPlayer = ig.data.GetPlayer(source)
        if not xPlayer then return false end
        
        local spawner = conf.job_vehicles.spawners[spawnerId]
        if not spawner then return false end
        
        local playerJob = xPlayer.GetJob()
        
        -- Verify job and grade
        if playerJob.Name ~= spawner.job then
            return false
        end
        
        if spawner.grade and playerJob.Grade < spawner.grade then
            return false
        end
        
        -- Get vehicle model
        local vehicle = spawner.vehicles[vehicleIndex]
        if not vehicle then return false end
        
        local model = vehicle.model
        local spawn = spawner.spawn
        
        -- Create vehicle using existing framework function
        local entity, net = ig.func.CreateVehicle(model, spawn.x, spawn.y, spawn.z, spawn.h)
        
        if not entity or not net then
            ig.func.Debug_1("Failed to spawn job vehicle: " .. model)
            return false
        end
        
        -- Log vehicle spawn
        ig.func.Debug_2(("Job vehicle spawned: %s for player %s (%s)"):format(
            model, 
            xPlayer.GetName(), 
            playerJob.Name
        ))
        
        -- Return network ID
        return net
    end
})

-- ====================================================================================--
