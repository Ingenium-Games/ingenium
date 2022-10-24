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

local GetSkills = RegisterServerCallback({
    eventName = "GetSkills",
    eventCallback = function(source, ...)
        local xPlayer = c.data.GetPlayer(source)
        local Skills = xPlayer.GetSkills()
        return Skills
    end
})

local GetPlayerJob = RegisterServerCallback({
    eventName = "GetPlayerJob",
    eventCallback = function(source)
        local xPlayer = c.data.GetPlayer(source)
        local Job = xPlayer.GetJob()
        return Job
    end
})

