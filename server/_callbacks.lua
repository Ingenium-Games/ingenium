-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]] --


-- ====================================================================================--

local GetCurrentJobs = RegisterServerCallback({
    eventName = 'GetCurrentJobs',
    eventCallback = function(source, ...)
        local jobs = c.job.ActiveMembers()
        return jobs
    end
})