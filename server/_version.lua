-- ====================================================================================--

c.version = {}

-- ====================================================================================--
--

--- func desc
---@param . any
function c.version.Check(url, resourceName)
    if conf.versioncheck then
        local version = GetResourceMetadata(resourceName, "version")
        PerformHttpRequest(url, function(err, text, headers)
            --
            c.func.Debug_1("^0[ ^3Performing Update Check ^0: "..resourceName.." ] ")
            if (text ~= nil) then
                if version == text then
                    c.func.Debug_1("^0[ ^4Ok! ^0] ")
                else
                    print("\n")
                    c.func.Alert("Newer version of "..resourceName.." found")
                    c.func.Alert("[ Old : "..version.." ] ")
                    c.func.Alert("[ New : "..text.." ] ")        
                    print("\n")
                end
            else
                c.func.Debug_1("Unable to find version.txt on "..url)
            end
        end, "GET", "", "")
    end
end

--- func desc
---@param time any
---@param url any
---@param resourceName any
function c.version.LoopCheck(time, url, resourceName)
    local function Do()
        c.version.Check(url, resourceName)
        SetTimeout(time, Do)
    end
    SetTimeout(time, Do)
end

--- func desc
---@param hour any
---@param min any
---@param url any
---@param resourceName any
function c.version.CronCheck(hour, min, url, resourceName)
    c.cron.RunAt(h, m, function() c.version.Check(url, resourceName) end)
end