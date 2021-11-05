-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
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