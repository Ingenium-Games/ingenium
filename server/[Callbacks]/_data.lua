-- ====================================================================================--
local GetItems = RegisterServerCallback({
    eventName = "GetItems",
    eventCallback = function(source, ...)
        local items = c.item.GetItems()
        return items
    end
})

local GetJobs = RegisterServerCallback({
    eventName = "GetJobs",
    eventCallback = function(source, ...)
        local jobs = c.job.GetJobs()
        return jobs
    end
})

local GetDoors = RegisterServerCallback({
    eventName = "GetDoors",
    eventCallback = function(source, ...)
        local doors = c.door.GetDoors()
        return doors
    end
})

local GetObjects = RegisterServerCallback({
    eventName = "GetObjects",
    eventCallback = function(source, ...)
        local objs = c.door.GetObjects()
        return objs
    end
})
