--[[
    Vehicle Persistence Manager (Refactored)
    
    Event-driven architecture using existing vehicle events
    - Hooks into Server:PlayerEnteredVehicle for registration
    - Uses ig.func.* utilities for vehicle condition/mods
    - JSON file storage for persistent vehicle data
    - Minimal database queries (only for owned vehicles)
    
    Architecture:
    - Persistent vehicles stored in data/persistent_vehicles.json
    - In-memory cache (ig.vehicleCache) for quick lookups
    - Event-driven registration (no polling loops)
    - Periodic JSON sync (every 5 minutes)
    - Owned vehicles (Character_ID) stay in DB only
    - NPC/World vehicles tracked in JSON + cache
]]

if not ig.vehicle then ig.vehicle = {} end
ig.vehicleCache = {} -- In-memory cache: plate -> vehicle data
ig.persistentVehiclesFile = "data/persistent_vehicles.json"

-- ====================================================================================--

---Initialize vehicle persistence system
function ig.vehicle.InitializePersistence()
    if not conf.persistence or not conf.persistence.enablePersistence then
        ig.log.Warn("Vehicle persistence system is disabled via config")
        return
    end
    
    ig.log.Info("Initializing vehicle persistence system...")
    
    -- Load persistent vehicles from JSON file at startup
    ig.vehicle.LoadPersistentVehicles()
    
    -- Restore parked vehicles from database (marked as Parked during last server empty)
    ig.vehicle.RestoreParkedVehicles()
    
    -- Start periodic save thread (every 5 minutes)
    ig.vehicle.StartPeriodicSave()
    
    -- Hook into existing vehicle enter/exit events
    ig.vehicle.HookVehicleEvents()
    
    ig.log.Info("Vehicle persistence system initialized")
    ig.log.Debug("Loaded " .. ig.table.SizeOf(ig.vehicleCache) .. " persistent vehicles from cache")
end

---Load persistent vehicles from JSON file into memory
function ig.vehicle.LoadPersistentVehicles()
    local filePath = GetResourcePath(GetCurrentResourceName()) .. "/" .. ig.persistentVehiclesFile
    
    -- Check if file exists
    local fileHandle = io.open(filePath, "r")
    if not fileHandle then
        ig.log.Debug("No persistent vehicles file found. Starting fresh.")
        ig.vehicleCache = {}
        return
    end
    
    local content = fileHandle:read("*a")
    fileHandle:close()
    
    if not content or content == "" then
        ig.vehicleCache = {}
        return
    end
    
    local success, data = pcall(json.decode, content)
    if not success or not data or not data.vehicles then
        ig.log.Warn("Failed to load persistent vehicles: invalid JSON")
        ig.vehicleCache = {}
        return
    end
    
    ig.vehicleCache = data.vehicles or {}
    ig.log.Info("Loaded " .. ig.table.SizeOf(ig.vehicleCache) .. " persistent vehicles from file")
end

---Restore parked vehicles from database (marked Parked during server empty)
---Unparks them and adds to cache for respawn
function ig.vehicle.RestoreParkedVehicles()
    if not ig.sql or not ig.sql.Query then
        ig.log.Warn("SQL system not available for parked vehicle restoration")
        return
    end
    
    local parkedVehicles = ig.sql.Query("SELECT * FROM `vehicles` WHERE `Parked` = TRUE;", {})
    
    if not parkedVehicles or #parkedVehicles == 0 then
        ig.log.Debug("No parked vehicles to restore from database")
        return
    end
    
    local restoredCount = 0
    
    for _, vehicleData in ipairs(parkedVehicles) do
        if vehicleData.Plate and vehicleData.Plate ~= "" then
            -- Only add to cache if not already there (JSON data takes precedence)
            if not ig.vehicleCache[vehicleData.Plate] then
                -- Add parked vehicle to cache for potential restoration
                ig.vehicleCache[vehicleData.Plate] = {
                    plate = vehicleData.Plate,
                    model = vehicleData.Model,
                    type = vehicleData.Character_ID and "owned" or "world",
                    owner = vehicleData.Character_ID,
                    registeredAt = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                    lastInteraction = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                    interactionCount = 0,
                    coords = vehicleData.Coords and json.decode(vehicleData.Coords) or {x = 0, y = 0, z = 0, h = 0},
                    fuel = vehicleData.Fuel or 100,
                    condition = vehicleData.Condition and json.decode(vehicleData.Condition) or nil,
                    modifications = vehicleData.Modifications and json.decode(vehicleData.Modifications) or nil,
                    statebag = {}
                }
                restoredCount = restoredCount + 1
            end
            
            -- Unpark the vehicle in database
            ig.sql.Update("UPDATE `vehicles` SET `Parked` = FALSE WHERE `Plate` = ?;", {vehicleData.Plate})
        end
    end
    
    if restoredCount > 0 then
        ig.log.Info("Restored " .. restoredCount .. " parked vehicles from database")
    end
end
---Save persistent vehicles to JSON file
function ig.vehicle.SavePersistentVehicles()
    local dataToSave = {
        version = 1,
        lastSaved = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        vehicles = ig.vehicleCache
    }
    
    local filePath = GetResourcePath(GetCurrentResourceName()) .. "/" .. ig.persistentVehiclesFile
    
    -- Create data directory if needed
    local dataDir = GetResourcePath(GetCurrentResourceName()) .. "/data"
    os.execute("mkdir -p " .. dataDir)
    
    local fileHandle = io.open(filePath, "w")
    if not fileHandle then
        ig.log.Error("Failed to open persistent vehicles file for writing: " .. filePath)
        return false
    end
    
    local success, json_str = pcall(json.encode, dataToSave)
    if not success then
        ig.log.Error("Failed to encode persistent vehicles to JSON")
        fileHandle:close()
        return false
    end
    
    fileHandle:write(json_str)
    fileHandle:close()
    
    if conf.persistence.logging.enabled then
        ig.log.Debug("Saved " .. ig.table.SizeOf(ig.vehicleCache) .. " persistent vehicles to file")
    end
    
    return true
end

---Start periodic save thread - saves to JSON every 5 minutes
function ig.vehicle.StartPeriodicSave()
    CreateThread(function()
        while ig.vehicle and conf.persistence.enablePersistence do
            Wait(300000) -- 5 minutes
            
            if conf.persistence.logging.enabled then
                ig.log.Debug("Starting periodic persistent vehicle save...")
            end
            
            ig.vehicle.SavePersistentVehicles()
        end
    end)
end

---Register vehicle as persistent (called when player enters vehicle)
---@param vehicleEntity number Vehicle entity handle
---@param playerId number Player server ID
---@param plate string Vehicle plate
---@param vehicleType string Type: 'owned', 'npc', 'world'
---@param npcOwner string NPC identifier if applicable
function ig.vehicle.RegisterPersistent(vehicleEntity, playerId, plate, vehicleType, npcOwner)
    if not plate or plate == "" then
        ig.log.Warn("Cannot register vehicle with empty plate")
        return
    end
    
    -- Skip if already registered
    if ig.vehicleCache[plate] then
        if conf.persistence.logging.enabled then
            ig.log.Debug("Vehicle already registered: " .. plate)
        end
        
        -- Update interaction count
        ig.vehicleCache[plate].interactionCount = (ig.vehicleCache[plate].interactionCount or 0) + 1
        ig.vehicleCache[plate].lastInteraction = os.date("!%Y-%m-%dT%H:%M:%SZ")
        return
    end
    
    local player = GetPlayer(playerId)
    if not player then return end
    
    if not DoesEntityExist(vehicleEntity) then return end
    
    -- Capture vehicle state using ig.func utilities
    local vehicleModel = GetEntityModel(vehicleEntity)
    local coords = GetEntityCoords(vehicleEntity)
    
    ig.vehicleCache[plate] = {
        plate = plate,
        model = vehicleModel,
        type = vehicleType or "world",
        npcOwner = npcOwner,
        owner = player.character_id,
        registeredBy = playerId,
        registeredAt = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        lastInteraction = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        interactionCount = 1,
        coords = {x = coords.x, y = coords.y, z = coords.z, h = GetEntityHeading(vehicleEntity)},
        fuel = GetVehicleFuelLevel(vehicleEntity),
        mileage = 0,
        -- Condition/modifications will be captured by client
        condition = nil,
        modifications = nil,
        statebag = {}
    }
    
    -- Update database with registration (for backup/admin queries)
    ig.sql.veh.RegisterPersistent(plate, vehicleType, npcOwner, function(affectedRows)
        if conf.persistence.logging.enabled then
            ig.log.Info("Vehicle registered as persistent in DB: " .. plate)
        end
    end)
    
    -- Request client to capture full vehicle condition
    TriggerClientEvent("vehicle:persistence:captureCondition", playerId, plate, vehicleEntity)
    
    if conf.persistence.logging.enabled then
        ig.log.Info("Vehicle registered as persistent: " .. plate .. " by player " .. playerId)
    end
end

---Update vehicle state (called when client sends condition data)
---@param plate string Vehicle plate
---@param condition table Vehicle condition data from client
---@param modifications table Vehicle modifications from client
function ig.vehicle.UpdateVehicleState(plate, condition, modifications)
    if not ig.vehicleCache[plate] then
        ig.log.Warn("Attempting to update state for unregistered vehicle: " .. plate)
        return
    end
    
    local vehicleData = ig.vehicleCache[plate]
    vehicleData.condition = condition
    vehicleData.modifications = modifications
    vehicleData.lastInteraction = os.date("!%Y-%m-%dT%H:%M:%SZ")
    
    -- Update database async
    ig.sql.veh.UpdateVehicleState(plate, condition, modifications)
end

---Update vehicle position and fuel
---@param plate string Vehicle plate
---@param coords table Vehicle coordinates
---@param heading number Vehicle heading
---@param fuel number Current fuel level
function ig.vehicle.UpdateVehicleLocation(plate, coords, heading, fuel)
    if not ig.vehicleCache[plate] then
        return
    end
    
    ig.vehicleCache[plate].coords = coords
    ig.vehicleCache[plate].fuel = fuel
    ig.vehicleCache[plate].lastInteraction = os.date("!%Y-%m-%dT%H:%M:%SZ")
    
    -- Update database
    ig.sql.veh.UpdatePosition(plate, coords)
    ig.sql.veh.UpdateVehicleStats(plate, fuel, 0)
end

---Get persistent vehicle by plate
---@param plate string Vehicle plate
---@return table Vehicle data or nil
function ig.vehicle.GetPersistentVehicle(plate)
    return ig.vehicleCache[plate]
end

---Get all persistent vehicles
---@return table All cached vehicle data
function ig.vehicle.GetAllPersistentVehicles()
    return ig.vehicleCache
end

---Restore vehicle from persistent data (spawn)
---Uses ig.func utilities for setting condition/modifications
---@param vehicleData table Vehicle data from cache
---@return number Vehicle entity handle or nil
function ig.vehicle.RestorePersistentVehicle(vehicleData)
    if not vehicleData or not vehicleData.model then
        ig.log.Warn("Cannot restore vehicle: missing model")
        return nil
    end
    
    local modelHash = vehicleData.model
    local coords = vehicleData.coords or {x = 0, y = 0, z = 0, h = 0}
    
    -- Request model with timeout
    RequestModel(modelHash)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(modelHash) and GetGameTimer() < timeout do
        Wait(10)
    end
    
    if not HasModelLoaded(modelHash) then
        ig.log.Error("Failed to load model for vehicle: " .. vehicleData.plate)
        return nil
    end
    
    -- Create vehicle at saved location
    local vehicle = CreateVehicle(modelHash, coords.x, coords.y, coords.z, coords.h or 0.0, true, false)
    
    if not DoesEntityExist(vehicle) then
        ig.log.Error("Failed to create vehicle entity: " .. vehicleData.plate)
        SetModelAsNoLongerNeeded(modelHash)
        return nil
    end
    
    -- Set plate
    SetVehicleNumberPlateText(vehicle, vehicleData.plate)
    
    -- Restore condition using ig.func utilities if available
    if vehicleData.condition and ig.func and ig.func.SetVehicleCondition then
        ig.func.SetVehicleCondition(vehicle, vehicleData.condition)
    end
    
    -- Restore modifications using ig.func utilities if available
    if vehicleData.modifications and ig.func and ig.func.SetVehicleModifications then
        ig.func.SetVehicleModifications(vehicle, vehicleData.modifications)
    end
    
    -- Set fuel
    if vehicleData.fuel then
        SetVehicleFuelLevel(vehicle, vehicleData.fuel)
    end
    
    -- Clean up model
    SetModelAsNoLongerNeeded(modelHash)
    
    if conf.persistence.logging.enabled then
        ig.log.Info("Restored persistent vehicle: " .. vehicleData.plate)
    end
    
    return vehicle
end

---Hook into existing vehicle events
function ig.vehicle.HookVehicleEvents()
    -- Hook into the existing Server:Vehicle:OnPlayerEntered event
    -- This event is already fired from server/[Events]/_vehicle.lua
    AddEventHandler("Server:Vehicle:OnPlayerEntered", function(playerId, vehicleEntity, seat)
        if not conf.persistence or not conf.persistence.enablePersistence then
            return
        end
        
        if not DoesEntityExist(vehicleEntity) then
            return
        end
        
        local plate = GetVehicleNumberPlateText(vehicleEntity)
        if not plate or plate == "" then
            return
        end
        
        -- Check if this is a player-owned vehicle (skip, already in DB)
        local player = GetPlayer(playerId)
        if not player then return end
        
        -- Register as persistent if not already in cache
        if not ig.vehicleCache[plate] then
            -- Default to 'world' type - can be overridden by garage/specific logic
            ig.vehicle.RegisterPersistent(vehicleEntity, playerId, plate, "world", nil)
        else
            -- Update last interaction
            ig.vehicleCache[plate].lastInteraction = os.date("!%Y-%m-%dT%H:%M:%SZ")
            ig.vehicleCache[plate].interactionCount = (ig.vehicleCache[plate].interactionCount or 0) + 1
        end
    end)
end


    if resource == GetCurrentResourceName() and ig.vehicle then
        ig.log.Info("Saving persistent vehicles on shutdown...")
        ig.vehicle.SavePersistentVehicles()
    end
end)



