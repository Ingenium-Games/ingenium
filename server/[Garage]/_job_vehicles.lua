-- ====================================================================================--
-- Job-Owned Vehicles System
-- Provides server-side handling for job-owned vehicles in the garage system
-- ====================================================================================--

-- Load job vehicles configuration
local jobVehiclesConfig = {}
local jobsData = {}

-- Initialize configuration on resource start
Citizen.CreateThread(function()
    -- Load job vehicles config
    local jobVehiclesFile = LoadResourceFile(GetCurrentResourceName(), "data/job_vehicles.json")
    if jobVehiclesFile then
        jobVehiclesConfig = json.decode(jobVehiclesFile)
        ig.func.Debug_1("[Job Vehicles] Loaded job vehicles configuration")
    else
        ig.func.Alert("[Job Vehicles] Failed to load data/job_vehicles.json")
        jobVehiclesConfig = {}
    end
    
    -- Load jobs data for grade validation
    local jobsFile = LoadResourceFile(GetCurrentResourceName(), "data/jobs.json")
    if jobsFile then
        jobsData = json.decode(jobsFile)
        ig.func.Debug_1("[Job Vehicles] Loaded jobs data for validation")
    else
        ig.func.Alert("[Job Vehicles] Failed to load data/jobs.json")
        jobsData = {}
    end
end)

-- ====================================================================================--
-- Helper Functions
-- ====================================================================================--

--- Get the rank/grade for a specific job role
---@param jobId string The job identifier
---@param roleName string The role/grade name
---@return number|nil The rank number or nil if not found
local function GetJobRoleRank(jobId, roleName)
    if not jobsData[jobId] then
        return nil
    end
    
    local jobRoles = jobsData[jobId]
    if jobRoles[roleName] and jobRoles[roleName].rank then
        return jobRoles[roleName].rank
    end
    
    return nil
end

--- Check if player has required grade/role for a vehicle
---@param playerJob table Player's job data with {job = "jobId", grade = "roleName"}
---@param vehicleConfig table Vehicle configuration from job_vehicles.json
---@return boolean True if player meets requirements
local function PlayerMeetsVehicleRequirements(playerJob, vehicleConfig)
    if not playerJob or not playerJob.job or not playerJob.grade then
        return false
    end
    
    -- Get player's rank
    local playerRank = GetJobRoleRank(playerJob.job, playerJob.grade)
    if not playerRank then
        ig.func.Debug_2("[Job Vehicles] Could not find rank for job: " .. tostring(playerJob.job) .. ", grade: " .. tostring(playerJob.grade))
        return false
    end
    
    -- Check minGrade requirement
    if vehicleConfig.minGrade and playerRank < vehicleConfig.minGrade then
        return false
    end
    
    -- Check allowedRoles if specified (allowedRoles takes precedence)
    if vehicleConfig.allowedRoles and type(vehicleConfig.allowedRoles) == "table" then
        local roleAllowed = false
        for _, allowedRole in ipairs(vehicleConfig.allowedRoles) do
            if playerJob.grade == allowedRole then
                roleAllowed = true
                break
            end
        end
        return roleAllowed
    end
    
    return true
end

-- ====================================================================================--
-- Server Callbacks & Exports
-- ====================================================================================--

--- Get job vehicles available to a player
--- Export: ingenium:GetJobVehiclesForPlayer
---@param playerId number The player's server ID
---@return table List of available job vehicles
local function GetJobVehiclesForPlayer(playerId)
    local xPlayer = ig.data.GetPlayer(playerId)
    if not xPlayer then
        ig.func.Debug_1("[Job Vehicles] Player not found: " .. tostring(playerId))
        return {}
    end
    
    local playerJob = xPlayer.GetJob()
    if not playerJob or not playerJob.job then
        ig.func.Debug_2("[Job Vehicles] Player has no job: " .. tostring(playerId))
        return {}
    end
    
    local jobId = playerJob.job
    if not jobVehiclesConfig[jobId] then
        ig.func.Debug_2("[Job Vehicles] No vehicles configured for job: " .. tostring(jobId))
        return {}
    end
    
    local availableVehicles = {}
    for _, vehicleConfig in ipairs(jobVehiclesConfig[jobId]) do
        if PlayerMeetsVehicleRequirements(playerJob, vehicleConfig) then
            table.insert(availableVehicles, {
                model = vehicleConfig.model,
                name = vehicleConfig.name,
                description = vehicleConfig.description or "",
                minGrade = vehicleConfig.minGrade or 1
            })
        end
    end
    
    ig.func.Debug_2("[Job Vehicles] Found " .. #availableVehicles .. " available vehicles for player " .. playerId)
    return availableVehicles
end

-- Export the function for use by other resources
exports("GetJobVehiclesForPlayer", GetJobVehiclesForPlayer)

-- Server callback for client requests
local GetJobVehicles = RegisterServerCallback({
    eventName = "ingenium:GetJobVehicles",
    eventCallback = function(source)
        return GetJobVehiclesForPlayer(source)
    end
})

-- ====================================================================================--
-- Network Event Handlers
-- ====================================================================================--

--- Handle job vehicle spawn requests from client
--- Validates player's job/grade and spawns vehicle server-side
RegisterServerCallback({
    eventName = "ingenium:SpawnJobVehicle",
    eventCallback = function(source, vehicleModel, spawnLocation)
        local playerId = source
        
        -- Validate player
        local xPlayer = ig.data.GetPlayer(playerId)
        if not xPlayer then
            ig.func.Alert("[Job Vehicles] Spawn request from invalid player: " .. tostring(playerId))
            return false, "Player not found"
        end
        
        -- Get player's job
        local playerJob = xPlayer.GetJob()
        if not playerJob or not playerJob.job then
            ig.func.Debug_1("[Job Vehicles] Spawn request from player without job: " .. tostring(playerId))
            TriggerClientEvent("Client:Notify", playerId, "You don't have a job to spawn vehicles", 2)
            return false, "No job"
        end
        
        -- Validate vehicle is allowed for this job
        local jobId = playerJob.job
        if not jobVehiclesConfig[jobId] then
            ig.func.Debug_1("[Job Vehicles] No vehicles configured for job: " .. tostring(jobId))
            TriggerClientEvent("Client:Notify", playerId, "No vehicles available for your job", 2)
            return false, "No vehicles configured"
        end
        
        -- Find the vehicle in job config and validate permissions
        local vehicleConfig = nil
        for _, vConfig in ipairs(jobVehiclesConfig[jobId]) do
            if vConfig.model == vehicleModel then
                vehicleConfig = vConfig
                break
            end
        end
        
        if not vehicleConfig then
            ig.func.Alert("[Job Vehicles] Player " .. playerId .. " requested invalid vehicle: " .. tostring(vehicleModel))
            TriggerClientEvent("Client:Notify", playerId, "Invalid vehicle requested", 2)
            return false, "Invalid vehicle"
        end
        
        -- Check if player meets requirements
        if not PlayerMeetsVehicleRequirements(playerJob, vehicleConfig) then
            ig.func.Debug_1("[Job Vehicles] Player " .. playerId .. " doesn't meet requirements for vehicle: " .. vehicleModel)
            TriggerClientEvent("Client:Notify", playerId, "You don't have the required grade for this vehicle", 2)
            return false, "Insufficient grade"
        end
        
        -- Validate spawn location
        if not spawnLocation or not spawnLocation.x or not spawnLocation.y or not spawnLocation.z then
            ig.func.Alert("[Job Vehicles] Invalid spawn location from player: " .. playerId)
            return false, "Invalid spawn location"
        end
        
        -- Spawn the vehicle server-side
        ig.func.Debug_1("[Job Vehicles] Spawning " .. vehicleModel .. " for player " .. playerId .. " at job: " .. jobId)
        
        local entity = CreateVehicle(GetHashKey(vehicleModel), spawnLocation.x, spawnLocation.y, spawnLocation.z, spawnLocation.h or 0.0, true, false)
        
        -- Wait for entity to exist (with timeout)
        local startTime = GetGameTimer()
        local timeout = 3000
        
        while not DoesEntityExist(entity) do
            local elapsed = GetGameTimer() - startTime
            if elapsed >= timeout then
                ig.func.Alert("[Job Vehicles] Timeout creating vehicle for player " .. playerId)
                TriggerClientEvent("Client:Notify", playerId, "Failed to spawn vehicle (timeout)", 2)
                return false, "Spawn timeout"
            end
            Citizen.Wait(10)
        end
        
        local net = NetworkGetNetworkIdFromEntity(entity)
        
        -- Add vehicle to game data as a non-owned (job) vehicle
        -- Using ig.class.Vehicle (not OwnedVehicle) since this is a job vehicle
        ig.data.AddVehicle(net, ig.class.Vehicle, net)
        
        ig.func.Debug_1("[Job Vehicles] Successfully spawned vehicle (net: " .. net .. ") for player " .. playerId)
        TriggerClientEvent("Client:Notify", playerId, "Job vehicle spawned: " .. (vehicleConfig.name or vehicleModel), 1)
        
        return true, net
    end
})

-- ====================================================================================--
-- Server Export: SpawnVehicleForPlayer
-- Placeholder/wrapper export that other systems can use
-- This can be replaced or redirected to actual spawn implementation if needed
-- ====================================================================================--

--- Spawn a vehicle for a player (generic export)
--- This is a wrapper that can be used by other resources
---@param playerId number The player's server ID
---@param vehicleModel string The vehicle model name
---@param spawnLocation table Spawn location {x, y, z, h}
---@return boolean success, any result Network ID or error message
exports("SpawnVehicleForPlayer", function(playerId, vehicleModel, spawnLocation)
    -- For now, this just spawns a regular vehicle
    -- Other systems can hook into this or replace it with custom spawn logic
    
    if not playerId or not vehicleModel or not spawnLocation then
        return false, "Invalid parameters"
    end
    
    local entity = CreateVehicle(GetHashKey(vehicleModel), spawnLocation.x, spawnLocation.y, spawnLocation.z, spawnLocation.h or 0.0, true, false)
    
    local startTime = GetGameTimer()
    local timeout = 3000
    
    while not DoesEntityExist(entity) do
        local elapsed = GetGameTimer() - startTime
        if elapsed >= timeout then
            return false, "Spawn timeout"
        end
        Citizen.Wait(10)
    end
    
    local net = NetworkGetNetworkIdFromEntity(entity)
    ig.data.AddVehicle(net, ig.class.Vehicle, net)
    
    return true, net
end)

-- ====================================================================================--
ig.func.Debug_1("[Job Vehicles] System initialized")
-- ====================================================================================--
