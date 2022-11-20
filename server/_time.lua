-- ====================================================================================--

c.time = {} -- functions

-- ====================================================================================--

--- func desc
function c.time.Update()
    local time = os.date("*t")
    SetConvarReplicated("Time", os.date("%H:%M", os.time() + conf.altertime * 60 * 60))
    SetConvarServerInfo("Server Time", os.date("%H:%M"))
    c.cron.OnTime(time.hour, time.min)
end

--- func desc
function c.time.ServerSync()
    c.time.Update()
    local function Do()
        c.time.Update()
        SetTimeout(c.min, Do)
    end
    SetTimeout(c.min, Do)
end