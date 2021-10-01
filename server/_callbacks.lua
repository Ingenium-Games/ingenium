-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]] --

math.randomseed(c.Seed)
-- ====================================================================================--

local GetCurrentJobs = RegisterServerCallback({
    eventName = 'GetCurrentJobs',
    eventCallback = function(source, ...)
        local jobs = c.job.ActiveMembers()
        return jobs
    end
})