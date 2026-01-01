-- ====================================================================================--
-- Data Protection
-- Applies read-only protection to configuration and data tables
-- Prevents client-side modification of loaded data structures
-- ====================================================================================--

Citizen.CreateThread(function()
    -- Wait for all initialization to complete
    Wait(0)
    
    -- Protect the conf table and all nested tables
    if conf then
        local originalConf = conf
        conf = ig.table.MakeReadOnly(originalConf, "conf")
        
        print('^2[ingenium] Configuration tables protected from modification^0')
    end
end)

-- ====================================================================================--
