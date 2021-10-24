
-- ====================================================================================--
-- If this is the server,,,
-- Wait until the resources are hopefully finished loading by reading the console output fot the cfx.re tebex line.
-- We may have to make a final resource to jerry rig this if not the case.
if IsDuplicityVersion() then
    RegisterConsoleListener(function(channel, string)
        if channel == conf.consolechannel and string == conf.lock then
            c.json.Write("Doors", c.doors)
            setmetatable(c.doors, c.meta)
            c.debug_2("Doors table locked")      
        end
    end)
end
-- ====================================================================================--