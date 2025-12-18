-- ====================================================================================--
ig.version = {}
-- ====================================================================================--
--

--- func desc
---@param . any
function ig.version.Check(url, resourceName)
    if conf.versioncheck then
        local version = GetResourceMetadata(resourceName, "version")
        PerformHttpRequest(url, function(err, text, headers)
            --
            ig.funig.Debug_1("^0[ ^3Performing Update Check ^0: "..resourceName.." ] ")
            if (text ~= nil) then
                if version == text then
                    ig.funig.Debug_1("^0[ ^4Ok! ^0] ")
                else
                    print("\n")
                    ig.funig.Alert("Newer version of "..resourceName.." found")
                    ig.funig.Alert("[ Old : "..version.." ] ")
                    ig.funig.Alert("[ New : "..text.." ] ")        
                    print("\n")
                end
            else
                ig.funig.Debug_1("Unable to find version.txt on "..url)
            end
        end, "GET", "", "")
    end
end

--- func desc
---@param time any
---@param url any
---@param resourceName any
function ig.version.LoopCheck(time, url, resourceName)
    local function Do()
        ig.version.Check(url, resourceName)
        SetTimeout(time, Do)
    end
    SetTimeout(time, Do)
end

--- func desc
---@param hour any
---@param min any
---@param url any
---@param resourceName any
function ig.version.CronCheck(hour, min, url, resourceName)
    ig.cron.RunAt(hour, min, function() ig.version.Check(url, resourceName) end)
end