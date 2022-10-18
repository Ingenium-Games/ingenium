-- ====================================================================================--
c.time = {}
-- ====================================================================================--

-- I miss NetworkOverrideClockMillisecondsPerGameMinute()

local time = {0,0}

--- Get the current server time based on the GetConvar("Time").
function c.time.GetTime()
    local time = GetConvar("Time", "00:00")
    local hour = tonumber(time:sub(1,2))
    local min = tonumber(time:sub(4,5))
    return {hour, min}
end

-- Set a timeout loop to request the time again.
function c.time.UpdateTime()
    time = c.time.GetTime()
    local function Do()
        time = c.time.GetTime()
        SetTimeout(c.min, Do)
    end
    SetTimeout(c.min, Do)
end

Citizen.CreateThread(function() 
    while true do
        Wait(1250)
        NetworkOverrideClockTime(time[1], time[2])
    end
end)