-- ====================================================================================--
conf.vehicles = {}
-- ====================================================================================--
conf.vehicles.classes = {
  "Compact",
  "Sedan",
  "SUV",
  "Coupe",
  "Muscle",
  "Sports Classic",
  "Sport",
  "Super",
  "Motorcycles",
  "Off-road",
  "Industrial",
  "Utility",
  "Van",
  "Cycle",
  "Boat",
  "Helicopter",
  "Plane",
  "Service",
  "Emergency",
  "Military",
  "Commercial",
  "Train"
}

-- ====================================================================================--
-- VEHICLE PERSISTENCE SYSTEM CONFIGURATION
-- ====================================================================================--

conf.persistence = {
    -- === PERSISTENCE BEHAVIOR ===
    enablePersistence = true,
    enableNpcVehiclePersistence = true,
    
    -- === VEHICLE CLASSIFICATION ===
    npcVehicle = {
        maxInteractionTime = 300000, -- 5 minutes: If NPC vehicle not entered within this time, delete instead of persist
        autoRegisterOnEnter = true, -- Register as persistent when player enters
    },
    
    -- === SPAWN & DESPAWN ===
    spawnDistance = 200, -- Distance players must be within to spawn vehicles
    spawnTimeout = 10000, -- Interval between spawn checks (ms)
    maxSpawnsPerTick = 5, -- Max vehicles to spawn per tick to prevent lag
    despawnDistance = 400, -- Distance from all players before despawn
    
    -- === PARKING & PERSISTENCE ===
    parking = {
        despawnWhenParked = false, -- If true, remove from world when marked as parked
        persistWhileParked = true, -- Keep in DB even when parked
        updateCoordsIfChanged = true, -- Restore to saved coords if moved while parked
        parkingUpdateInterval = 30000, -- Check for parking status every 30s
    },
    
    -- === VEHICLE STATE TRACKING ===
    stateTracking = {
        trackDamage = true, -- Track and save damage states
        trackLiveries = true, -- Track and save liveries
        trackStatebag = true, -- Track xvehicle and custom statebags
        trackFuel = true, -- Track fuel consumption
        trackMileage = true, -- Track mileage changes
        
        -- Detection thresholds
        damageCheckInterval = 5000, -- Check damage every 5s
        positionCheckInterval = 10000, -- Check position changes every 10s
        movementThreshold = 5.0, -- Minimum distance to register as moved
    },
    
    -- === CLEANUP & MAINTENANCE ===
    cleanup = {
        enabled = true,
        runInterval = 60000, -- Run cleanup every 60s
        
        -- Remove vehicles that haven't been accessed in X time
        abandonedVehicleTimeout = 604800000, -- 7 days in ms
        
        -- Remove unregistered (not player-entered) NPC vehicles after X time
        npcVehicleTimeout = 1800000, -- 30 minutes in ms
        
        -- Maximum vehicles to track in DB (oldest parked removed first)
        maxTrackedVehicles = 500,
    },
    
    -- === PLAYER DISCONNECTION ===
    onPlayerLeave = {
        -- If player owns a vehicle, who takes server ownership?
        transferOwnership = false, -- Transfer to NPC name / random name
        markAsDespawned = false, -- Mark as despawned pending re-entry
        clearPlayerData = true, -- Remove player identifiers from vehicle
    },
    
    -- === NPC VEHICLE REGISTRATION ===
    npcRegistration = {
        -- Auto-register NPC name when vehicle spawned
        useNpcName = true,
        fallbackToRandom = true, -- Use random name if NPC name unavailable
        
        -- Naming patterns
        randomNameFormat = "NPC_%s_%d", -- NPC_[MODEL]_[ID]
        
        -- Register on certain vehicle spawns
        registerAllNpcVehicles = false, -- If false, only register when player interacts
        registerAmbientTraffic = false, -- Register ambient traffic spawns
    },
    
    -- === DATABASE SYNC ===
    databaseSync = {
        batchUpdateInterval = 10000, -- Batch save changes every 10s
        maxBatchSize = 50, -- Max vehicles per batch update
        
        -- Enable async DB operations
        asyncUpdates = true,
        
        -- Persistence state table
        useStateTable = true, -- Use vehicle_persistence_state for quick lookups
        cacheTimeout = 300000, -- Invalidate cache every 5 minutes
    },
    
    -- === INTERACTION DETECTION ===
    interactions = {
        -- Detect when player enters vehicle
        detectSeatEntry = true,
        detectEngineStart = false, -- Also trigger on engine start?
        
        -- Minimum interaction to register
        minInteractionDuration = 1000, -- Must be in seat for 1s to register
    },
    
    -- === LOGGING ===
    logging = {
        enabled = true,
        logLevel = "info", -- "trace", "debug", "info", "warn", "error"
        
        -- Log specific events
        logSpawns = true,
        logDespawns = true,
        logPersistence = true,
        logStateChanges = true,
        logInteractions = true,
    },
    
    -- === DEVELOPMENT ===
    dev = {
        debugMode = false, -- Extra logging and validation
        disableCleanup = false, -- Disable cleanup routine for testing
        logAllUpdates = false, -- Log every vehicle state update
    },
}

-- === VEHICLE TYPE CONFIGURATIONS ===
-- Define specific rules for different vehicle types

conf.persistence.types = {
    -- Player-owned vehicles (from garage)
    owned = {
        persistent = true,
        trackState = true,
        allowNpcInteraction = false,
        despawnWhenParked = false,
        maxStorageDays = 90, -- Delete if not accessed in 90 days
    },
    
    -- NPC-driven vehicles (spawned by game)
    npc = {
        persistent = false, -- Unless player interacts
        trackState = true,
        allowNpcInteraction = true,
        despawnWhenParked = true,
        timeoutMinutes = 30, -- Delete if no player interaction in 30 min
    },
    
    -- World-spawned vehicles
    world = {
        persistent = false, -- Unless player interacts
        trackState = true,
        allowNpcInteraction = false,
        despawnWhenParked = true,
        timeoutMinutes = 60, -- Delete if no player interaction in 60 min
    },
}

-- === STATEBAG PROPERTIES TO PERSIST ===
conf.persistence.persistStatebag = {
    "xvehicle", -- xVehicle framework data
    "vehicle_customization", -- Custom vehicle properties
    "vehicle_meta", -- Metadata set by scripts
    "livery_data", -- Livery information
}
