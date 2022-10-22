-- ====================================================================================--
local GetActiveWorkers = RegisterServerCallback({
    eventName = "GetActiveWorkers",
    eventCallback = function(source, ...)
        return c.job.ActiveMembers()
    end
})

local GetModifiers = RegisterServerCallback({
    eventName = "GetModifiers",
    eventCallback = function(source, ...)
        local xPlayer = c.data.GetPlayer(source)
        local Modifiers = xPlayer.GetModifiers()
        return Modifiers
    end
})

local GetPlayerJob = RegisterServerCallback({
    eventName = "GetPlayerJob",
    eventCallback = function(source)
        local xPlayer = c.data.GetPlayer(source)
        local job = xPlayer.GetJob()
        return job
    end
})

