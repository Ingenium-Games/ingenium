-- ====================================================================================--
-- Time management (ig.time initialized in client/_var.lua)
ig.times = {
    Live = {0, 0},
    OT = false,
}
-- ====================================================================================--
-- I miss NetworkOverrideClockMillisecondsPerGameMinute()

--- Get the current server time based on the GetConvar("Time").
function ig.time.GetTime()
    local t = GetConvar("Time", "00:00")
    local h, m = tonumber(t:sub(1,2)), tonumber(t:sub(4,5))
    return {h, m}
end

--- force the time set to hour and minute
function ig.time.SetTimeOverride(h, m)
    local _h, _m = ig.check.Number(h, 0, 23), ig.check.Number(m, 0, 59)
    ig.times.OT = {_h, _m}
end

function ig.time.ClearOverride()
    ig.times.OT = false
end

-- Set a timeout loop to request the time again.
function ig.time.UpdateTime()
    ig.times.Live = ig.time.GetTime()
    local function Do()
        ig.times.Live = ig.time.GetTime()
        SetTimeout(ig.min, Do)
    end
    SetTimeout(ig.min, Do)
end

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1250)
        if (not ig.times.OT) then
            NetworkOverrideClockTime(ig.times.Live[1], ig.times.Live[2])
        else
            NetworkOverrideClockTime(ig.times.OT[1], ig.times.OT[2])
        end
    end
end)