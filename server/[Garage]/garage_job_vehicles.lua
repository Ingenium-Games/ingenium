-- ====================================================================================--
-- Server-side Job Vehicle Handler
-- ====================================================================================--
-- Provides job-owned vehicles to authorized players and validates spawn requests.
--
-- Features:
-- - Auto-detects QBCore or ESX framework (falls back to generic stub if neither found)
-- - Validates player job, grade, and roles server-side
-- - Returns list of allowed vehicles to client
-- - Validates spawn requests before triggering client-side spawn
-- - Exports function for other resources to query allowed vehicles
--
-- Integration Notes:
-- - Added to fxmanifest.lua server_scripts section
-- - Requires _config/job_vehicles.lua to be loaded first (via shared_scripts)
-- - Client listens for 'ingenium:receiveJobVehicles' event
-- - Spawn is handled via 'ingenium:clientSpawnVehicle' client event
--
-- Events:
-- - ingenium:requestJobVehicles (client->server) - Request allowed vehicles
-- - ingenium:spawnJobVehicle (client->server) - Request to spawn a job vehicle
--
-- Exports:
-- - GetJobVehiclesForPlayer(playerId) - Returns table of allowed vehicles for player
-- ====================================================================================--

local function log(fmt, ...)
  print(('[ingenium|job-vehicles] %s'):format(string.format(fmt, ...)))
end

-- Framework Detection
-- ====================================================================================--
local QBCore = nil
local ESX = nil
local frameworkDetected = false

-- Try to detect QBCore
if GetResourceState("qb-core") == "started" then
  local ok, qb = pcall(function() return exports["qb-core"]:GetCoreObject() end)
  if ok and qb then 
    QBCore = qb 
    frameworkDetected = true
    log('QBCore framework detected')
  end
end

-- Try to detect ESX
if not frameworkDetected and GetResourceState("es_extended") == "started" then
  local ok = pcall(function() 
    ESX = exports["es_extended"]:getSharedObject()
  end)
  if ok and ESX then 
    frameworkDetected = true
    log('ESX framework detected')
  end
end

if not frameworkDetected then
  log('WARNING: No QBCore or ESX detected. getPlayerJobInfo must be adapted for your framework.')
end

-- Helper Functions
-- ====================================================================================--

-- Get player's job information in a normalized format
-- Returns: { job = string, grade = number, roles = table }
local function getPlayerJobInfo(source)
  if QBCore then
    local player = QBCore.Functions.GetPlayer(source)
    if not player then 
      return { job = nil, grade = 0, roles = {} } 
    end
    
    local job = player.PlayerData.job and player.PlayerData.job.name
    local grade = 0
    
    -- Handle different QBCore grade structures
    if player.PlayerData.job then
      if player.PlayerData.job.grade and type(player.PlayerData.job.grade) == "table" then
        grade = player.PlayerData.job.grade.level or 0
      elseif player.PlayerData.job.grade then
        grade = player.PlayerData.job.grade
      end
    end
    
    -- QBCore doesn't have roles by default, but some servers add them
    -- Try to read from metadata if available
    local roles = {}
    if player.PlayerData.metadata and player.PlayerData.metadata.jobRole then
      table.insert(roles, player.PlayerData.metadata.jobRole)
    end
    
    return { job = job, grade = tonumber(grade) or 0, roles = roles }
    
  elseif ESX then
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
      return { job = nil, grade = 0, roles = {} } 
    end
    
    local job = xPlayer.job and xPlayer.job.name
    local grade = xPlayer.job and xPlayer.job.grade or 0
    
    -- ESX doesn't typically have roles either
    -- If your ESX server stores roles, adapt here
    local roles = {}
    
    return { job = job, grade = tonumber(grade) or 0, roles = roles }
    
  else
    -- No framework detected - stub implementation
    -- You MUST implement this for your custom framework
    log('WARNING: Stub getPlayerJobInfo called. No job data available.')
    return { job = nil, grade = 0, roles = {} }
  end
end

-- Check if a vehicle entry is allowed for the player
local function vehicleAllowedForPlayer(entry, playerJob, playerGrade, playerRoles)
  -- Check minimum grade requirement
  if entry.minGrade then
    local gradeNum = tonumber(playerGrade) or 0
    local minGradeNum = tonumber(entry.minGrade) or 0
    if gradeNum < minGradeNum then
      return false
    end
  end

  -- Check role requirements
  if entry.roles and #entry.roles > 0 then
    local roleMatched = false
    for _, requiredRole in ipairs(entry.roles) do
      for _, playerRole in ipairs(playerRoles or {}) do
        if playerRole == requiredRole then 
          roleMatched = true 
          break 
        end
      end
      if roleMatched then break end
    end
    if not roleMatched then 
      return false 
    end
  end

  return true
end

-- Build list of allowed vehicles for a player
local function buildAllowedVehiclesForPlayer(src)
  local info = getPlayerJobInfo(src)
  
  -- No job or job data unavailable
  if not info or not info.job then 
    return {} 
  end
  
  -- Get job vehicles config
  if not conf or not conf.garage or not conf.garage.job_vehicles then
    log('ERROR: Job vehicles config not found. Ensure _config/job_vehicles.lua is loaded.')
    return {}
  end
  
  local jobConfig = conf.garage.job_vehicles[info.job]
  if not jobConfig or not jobConfig.vehicles then 
    return {} 
  end

  -- Filter vehicles based on player's grade and roles
  local allowedVehicles = {}
  for _, vehicle in ipairs(jobConfig.vehicles) do
    if vehicleAllowedForPlayer(vehicle, info.job, info.grade, info.roles) then
      table.insert(allowedVehicles, {
        model = vehicle.model,
        label = vehicle.label or vehicle.model,
        spawnProps = vehicle.spawnProps or {}
      })
    end
  end
  
  return allowedVehicles
end

-- Network Events
-- ====================================================================================--

-- Client requests their allowed job vehicles
RegisterNetEvent('ingenium:requestJobVehicles', function()
  local src = source
  local vehicles = buildAllowedVehiclesForPlayer(src)
  
  -- Send back to requesting client
  TriggerClientEvent('ingenium:receiveJobVehicles', src, vehicles)
end)

-- Client requests to spawn a job vehicle
RegisterNetEvent('ingenium:spawnJobVehicle', function(data)
  local src = source
  
  -- Validate request data
  if type(data) ~= 'table' or type(data.model) ~= 'string' then
    log('spawnJobVehicle: Invalid data from player %s', tostring(src))
    return
  end

  local model = data.model
  local spawnCoords = data.spawnCoords

  -- Check if player is allowed to spawn this vehicle
  local allowed = false
  local allowedVehicles = buildAllowedVehiclesForPlayer(src)
  
  for _, vehicle in ipairs(allowedVehicles) do
    if vehicle.model == model then 
      allowed = true 
      break 
    end
  end
  
  if not allowed then
    log('Denied spawn request: player %s attempted to spawn %s (not authorized)', tostring(src), tostring(model))
    return
  end

  -- Player is authorized - trigger client-side spawn
  -- NOTE: This triggers a client event for the spawn. The client handles the actual vehicle creation.
  -- If your project uses server-side vehicle spawning, replace this with your server spawn function.
  log('Authorized spawn: player %s spawning job vehicle %s', tostring(src), tostring(model))
  TriggerClientEvent('ingenium:clientSpawnVehicle', src, { 
    model = model, 
    coords = spawnCoords, 
    owned = true,
    jobVehicle = true
  })
end)

-- Exports
-- ====================================================================================--

-- Allow other resources to query allowed vehicles for a player
exports('GetJobVehiclesForPlayer', function(playerId)
  return buildAllowedVehiclesForPlayer(playerId)
end)

-- ====================================================================================--
log('Job vehicle system initialized')
