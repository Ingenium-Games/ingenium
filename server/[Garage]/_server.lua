-- ====================================================================================--
AddEventHandler("onResourceStart", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    c.version.Check(conf.url.version, resourceName)
end)
-- ====================================================================================--
