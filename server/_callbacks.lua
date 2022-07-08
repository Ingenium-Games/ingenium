-- ====================================================================================--

--[[
NOTES
    -
]] --
-- ====================================================================================--
local GetAuthorisedPeds = RegisterServerCallback({
    eventName = "GetAuthorisedPeds",
    eventCallback = function(source)
        local License_ID = c.identifier(source)
        local peds = MySQL.Sync.fetchScalar("SELECT `Permited_C` FROM `users` WHERE `License_ID` = @License_ID;")
        return peds
    end
})

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

local GetActiveWorkers = RegisterServerCallback({
    eventName = "GetActiveWorkers",
    eventCallback = function(source, ...)
        return c.job.ActiveMembers()
    end
})

local UseItem = RegisterServerCallback({
    eventName = "UseItem",
    eventCallback = function(source, slot)
        
    end
})

-- ====================================================================================--

local cb = RegisterServerCallback({
    eventName = "GetDump",
    eventCallback = function(source, dump)
        if dump == "peds" then
            return exports["ig.dump"]:GetPeds()
        elseif dump == "tattoos" then
            return exports["ig.dump"]:GetTattoos()
        elseif dump == "zones" then
            return exports["ig.dump"]:GetZones()
        elseif dump == "weapons" then
            return exports["ig.dump"]:GetWeapons()
        elseif dump == "vehicles" then
            return exports["ig.dump"]:GetVehicles()
        elseif dump == "vehiclemodkits" then
            return exports["ig.dump"]:GetVehicleModKits()
        elseif dump == "cctvs" then
            return exports["ig.dump"]:GetCCTV()
        end    
    end
})