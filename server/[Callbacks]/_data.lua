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

--- Batch initialization callback: Returns all data needed for client startup in a single request
--- Reduces network overhead by combining multiple callbacks into one
local GetInitializationData = RegisterServerCallback({
    eventName = "GetInitializationData",
    eventCallback = function(source, ...)
        ig.log.Info("Callbacks", "GetInitializationData called from source: %d", source)
        
        local function safeGetData()
            ig.log.Debug("Callbacks", "Fetching items...")
            local items = ig.item.GetItems()
            ig.log.Debug("Callbacks", "Fetching doors...")
            local doors = ig.door.GetDoors()
            ig.log.Debug("Callbacks", "Fetching objects...")
            local objects = ig.object.GetObjects()
            ig.log.Debug("Callbacks", "Fetching tattoos...")
            local tattoos = ig.tattoo.GetAll()
            ig.log.Debug("Callbacks", "Fetching weapons...")
            local weapons = ig.weapon.GetAll()
            ig.log.Debug("Callbacks", "Fetching peds...")
            local peds = ig.ped.GetAll()
            ig.log.Debug("Callbacks", "Fetching appearance constants...")
            local appearance_constants = ig.appearance.GetConstants()
            
            return {
                items = items,
                doors = doors,
                objects = objects,
                tattoos = tattoos,
                weapons = weapons,
                peds = peds,
                appearance_constants = appearance_constants
            }
        end
        
        local success, data = pcall(safeGetData)
        
        if not success then
            ig.log.Error("Callbacks", "ERROR in GetInitializationData: %s", tostring(data))
            return {}
        end
        
        ig.log.Info("Callbacks", "GetInitializationData: successfully collected data")
        ig.log.Debug("Callbacks", "  - items: %d", data.items and ig.table.SizeOf(data.items) or 0)
        ig.log.Debug("Callbacks", "  - doors: %d", data.doors and ig.table.SizeOf(data.doors) or 0)
        ig.log.Debug("Callbacks", "  - peds: %d (type: %s)", data.peds and ig.table.SizeOf(data.peds) or 0, type(data.peds))
        ig.log.Debug("Callbacks", "  - tattoos: %d", data.tattoos and ig.table.SizeOf(data.tattoos) or 0)
        ig.log.Debug("Callbacks", "  - appearance_constants keys: %d", data.appearance_constants and ig.table.SizeOf(data.appearance_constants) or 0)
        
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

local GetAppearanceConstants = RegisterServerCallback({
    eventName = "ig:GameData:GetAppearanceConstants",
    eventCallback = function(source)
        return ig.appearance.GetConstants()
    end
})

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