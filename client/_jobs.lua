-- ====================================================================================--
c.job = {} -- function level
c.jobs = false
--[[
NOTES
    -
]] --
-- ====================================================================================--

function c.job.SetJobs(jobs)
    if not c.jobs then
        c.items = jobs
    end
end

function c.job.GetJobs()
    return c.jobs
end

function c.job.Exists(name)
    if c.jobs[name] then
        return true
    else
        return false
    end
end
