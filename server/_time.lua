-- ====================================================================================--

c.time = {} -- functions
--[[
NOTES.
    -
    -
    -
]]--

-- ====================================================================================--

--- func desc
---@param h number "Can do any, but really only 0,23 will work."
function c.time.AlterTime(h)
    local h = c.check.Number(h, 0, 23)
    local _min, _max = 0, 23
    local timealter = conf.altertime
    if timealter <= -23 then timealter = -23 end
    if timealter >= 23 then timealter = 23 end
    local newhour = h + timealter
    if newhour <= _min then
        newhour = (_max - newhour)
    end
    if newhour >= _max then
        newhour = _min + (newhour - _max)
    end
    return newhour
end

--- func desc
function c.time.Update()
    local t = os.date("*t")
    local newt = c.time.AlterTime(t.hour)
    SetConvarReplicated("Time", string.format("%02d:%02d", newt, t.min))
    SetConvarServerInfo("Server Time", string.format("%02d:%02d", t.hour, t.min))
    -- Add Cron Handler into the Time Functions.
    c.cron.Action(newt, t.min)
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