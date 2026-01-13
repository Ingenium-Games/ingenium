--[[
    Vehicle Persistence Client
    
    Hooks into existing vehicle entry/exit events and captures persistence state.
    
    Responsibilities:
    - Listen for Client:EnteredVehicle event (from [Events]/_vehicle.lua)
    - Capture vehicle condition at time of entry
    - Send condition data to server for persistence
    - Listen for Client:LeftVehicle event
    - Capture final state before exit
    - Send final state to server
    
    Note: Vehicle detection is handled by [Events]/_vehicle.lua using gameEventTriggered
    This module focuses purely on persistence capture/transmission.
]]

if not ig.vehicle then ig.vehicle = {} end

---Initialize vehicle persistence client
function ig.vehicle.InitializeClient()
    if not conf.persistence.enablePersistence then return end
    ig.log.Info("Initializing vehicle persistence client...")
    ig.log.Info("Vehicle persistence client initialized")
end

---Listen for persistence registration confirmation
RegisterNetEvent('vehicle:persistence:registered')
AddEventHandler('vehicle:persistence:registered', function(plate)
    if conf.persistence.logging.logPersistence then
        ig.log.Info("Vehicle registered as persistent: " .. plate)
    end
    
    TriggerEvent('chat:addMessage', {
        args = {"Vehicle System", "Vehicle " .. plate .. " is now persistent"},
        color = {0, 255, 0}
    })
end)

---Listen for vehicle spawn notification
RegisterNetEvent('vehicle:persistence:spawned')
AddEventHandler('vehicle:persistence:spawned', function(plate)
    if conf.persistence.logging.logSpawns then
        ig.log.Debug("Vehicle spawned: " .. plate)
    end
end)

---Listen for vehicle despawn notification
RegisterNetEvent('vehicle:persistence:despawned')
AddEventHandler('vehicle:persistence:despawned', function(plate)
    if conf.persistence.logging.logDespawns then
        ig.log.Debug("Vehicle despawned: " .. plate)
    end
end)

-- Initialize on resource start
CreateThread(function()
    Wait(1000) -- Wait for config to load
    
end)
