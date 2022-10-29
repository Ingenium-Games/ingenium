-- ====================================================================================--

c.time = {} -- functions

-- ====================================================================================--

--- func desc
---@param h number "Can do any, but really only 0,23 will work."
function c.time.AlterTime(h)
    local h = c.check.Number(h, 0, 23)
    local timealter = conf.altertime
    local new
    if (h + timealter) > 23 then
        new = (h + timealter) - 24
    end
    return new
end

--- func desc
function c.time.Update()
    local t = os.date("*t")
    local newt = c.time.AlterTime(t.hour)
    SetConvarReplicated("Time", string.format("%02d:%02d", newt, t.min))
    SetConvarServerInfo("Server Time", string.format("%02d:%02d", t.hour, t.min))
    c.cron.OnTime(newt, t.min)
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