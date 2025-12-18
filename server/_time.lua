-- ====================================================================================--
ig.time = {} -- functions
-- ====================================================================================--

--- func desc
function ig.time.Update()
    local time = os.date("*t")
    SetConvarReplicated("Time", os.date("%H:%M", os.time() + conf.altertime * 60 * 60))
    SetConvarServerInfo("Server Time", os.date("%H:%M"))
    ig.cron.OnTime(time.hour, time.min)
end

--- func desc
function ig.time.ServerSync()
    ig.time.Update()
    local function Do()
        ig.time.Update()
        SetTimeout(ig.min, Do)
    end
    SetTimeout(ig.min, Do)
end