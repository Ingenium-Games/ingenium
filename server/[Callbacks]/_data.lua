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
        return {
            items = ig.item.GetItems(),
            doors = ig.door.GetDoors(),
            objects = ig.door.GetObjects(),
            weapons = ig.weapons
        }
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

local GetModkitForVehicle = RegisterServerCallback({
    eventName = "ig:GameData:GetModkitForVehicle",
    eventCallback = function(source, vehicleHash)
        return ig.modkit.GetForVehicle(vehicleHash)
    end
})