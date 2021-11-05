-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
c.version = {}
--
function c.version.Check(url, resourceName)
    local version = GetResourceMetadata(resourceName, "version")
    PerformHttpRequest(url, function(err, text, headers)
        --
        c.debug_1("^0[ ^3Performing Update Check ^0: "..resourceName.." ] ")
        if (text ~= nil) then
            if version == text then
                c.debug_1("^0[ ^4Ok! ^0] ")
            else
                print("\n")
                c.alert("Newer version of "..resourceName.." found")
                c.alert("[ Old : "..version.." ] ")
                c.alert("[ New : "..text.." ] ")        
                print("\n")
            end
        else
            c.debug_1("Unable to find version.txt on "..url)
        end
    end, "GET", "", "")
end

function c.version.LoopCheck(time, url, resourceName)
    local function Do()
        c.version.Check(url, resourceName)
        SetTimeout(time, Do)
    end
    SetTimeout(time, Do)
end

function c.version.CronCheck(hour, min, url, resourceName)
    c.cron.Add(h, m, c.version.Check(url, resourceName))
end