-- ====================================================================================--
c.time = {}
c.times = {
    Live = {0, 0},
    OT = false,
}
-- ====================================================================================--
-- I miss NetworkOverrideClockMillisecondsPerGameMinute()

--- Get the current server time based on the GetConvar("Time").
function c.time.GetTime()
    local t = GetConvar("Time", "00:00")
    local h, m = tonumber(t:sub(1,2)), tonumber(t:sub(4,5))
    return {h, m}
end

--- force the time set to hour and minute
function c.time.SetTimeOverride(h, m)
    local _h, _m = c.check.Number(h, 0, 23), c.check.Number(m, 0, 59)
    c.times.OT = {_h, _m}
end

function c.time.ClearOverride()
    c.times.OT = false
end

-- Set a timeout loop to request the time again.
function c.time.UpdateTime()
    c.times.Live = c.time.GetTime()
    local function Do()
        c.times.Live = c.time.GetTime()
        SetTimeout(c.min, Do)
    end
    SetTimeout(c.min, Do)
end

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1250)
        if (not c.times.OT) then
            NetworkOverrideClockTime(c.times.Live[1], c.times.Live[2])
        else
            NetworkOverrideClockTime(c.times.OT[1], c.times.OT[2])
        end
    end
end)