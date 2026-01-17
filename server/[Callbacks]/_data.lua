-- ====================================================================================--
local GetItems = RegisterServerCallback({
    eventName = "GetItems",
    eventCallback = function(source, ...)
        local items = ig.item.GetItems()
        return items
    end
})

local GetJobs = RegisterServerCallback({
    eventName = "GetJobs",
    eventCallback = function(source, ...)
        local jobs = ig.job.GetJobs()
        return jobs
    end
})

local GetDoors = RegisterServerCallback({
    eventName = "GetDoors",
    eventCallback = function(source, ...)
        local doors = ig.door.GetDoors()
        return doors
    end
})

local GetObjects = RegisterServerCallback({
    eventName = "GetObjects",
    eventCallback = function(source, ...)
        local objs = ig.door.GetObjects()
        return objs
    end
})

--- Batch initialization callback: Returns DYNAMIC data needed for client startup
--- Static reference data (peds, tattoos, weapons, etc.) is loaded from client files
--- This only sends current runtime state that changes during gameplay
local GetInitializationData = RegisterServerCallback({
    eventName = "GetInitializationData",
    eventCallback = function(source, ...)
        ig.log.Info("Callbacks", "GetInitializationData called from source: %d (dynamic data only)", source)
        
        local function safeGetData()
            ig.log.Debug("Callbacks", "Fetching dynamic runtime data...")
            -- Only return dynamic data that changes during gameplay
            local doors = ig.door.GetDoors()
            local objects = ig.object.GetObjects()
            
            return {
                doors = doors,      -- Current door states (locked/unlocked)
                objects = objects   -- Current spawned objects
            }
        end
        
        local success, data = pcall(safeGetData)
        
        if not success then
            ig.log.Error("Callbacks", "ERROR in GetInitializationData: %s", tostring(data))
            return {}
        end
        
        ig.log.Info("Callbacks", "GetInitializationData: successfully collected dynamic data")
        ig.log.Debug("Callbacks", "  - doors: %d", data.doors and ig.table.SizeOf(data.doors) or 0)
        ig.log.Debug("Callbacks", "  - objects: %d", data.objects and ig.table.SizeOf(data.objects) or 0)
        
        return data
    end
})

local GetTattoos = RegisterServerCallback({
    eventName = "ig:GameData:GetTattoos",
    eventCallback = function(source)
        return ig.tattoos
    end
})

local GetTattoosByZone = RegisterServerCallback({
    eventName = "ig:GameData:GetTattoosByZone",
    eventCallback = function(source, zone)
        return ig.tattoo.GetByZone(zone)
    end
})

local GetWeapons = RegisterServerCallback({
    eventName = "ig:GameData:GetWeapons",
    eventCallback = function(source)
        return ig.weapons
    end
})

local GetVehicles = RegisterServerCallback({
    eventName = "ig:GameData:GetVehicles",
    eventCallback = function(source)
        return ig.vehicles
    end
})

local GetVehicleByHash = RegisterServerCallback({
    eventName = "ig:GameData:GetVehicleByHash",
    eventCallback = function(source, hash)
        return ig.vehicle.GetByHash(hash)
    end
})

local GetModkits = RegisterServerCallback({
    eventName = "ig:GameData:GetModkits",
    eventCallback = function(source)
        return ig.modkits
    end
})

-- GetAppearanceConstants callback removed - appearance constants are loaded
-- client-side from JSON and made read-only. No server request needed.

local GetPeds = RegisterServerCallback({
    eventName = "ig:GameData:GetPeds",
    eventCallback = function(source)
        return ig.ped.GetAll()
    end
})

local GetModkitForVehicle = RegisterServerCallback({
    eventName = "ig:GameData:GetModkitForVehicle",
    eventCallback = function(source, vehicleHash)
        return ig.modkit.GetForVehicle(vehicleHash)
    end
})