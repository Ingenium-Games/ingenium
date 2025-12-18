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
