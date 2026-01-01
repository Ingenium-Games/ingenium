-- ====================================================================================--
-- Data Protection
-- Applies read-only protection to configuration and data tables
-- Prevents client-side modification of loaded data structures
-- ====================================================================================--

-- Configuration
local INIT_DELAY_MS = 100  -- Delay in milliseconds to ensure all dependencies are loaded

Citizen.CreateThread(function()
    -- Wait for all tools and config to be fully loaded
    -- The config loads first, then tools (including ig.table), then this protection
    -- By this point in the load order, everything we need is available
    Wait(INIT_DELAY_MS)
    
    -- Verify dependencies are available
    if not ig or not ig.table or not ig.table.MakeReadOnly then
        print('^1[ingenium] Error: Protection dependencies not loaded. Cannot protect configuration tables.^0')
        return
    end
    
    -- Protect the conf table and all nested tables
    if conf then
        local originalConf = conf
        conf = ig.table.MakeReadOnly(originalConf, "conf")
        
        print('^2[ingenium] Configuration tables protected from modification^0')
    else
        print('^1[ingenium] Warning: conf table not found. Configuration protection not applied.^0')
    end
end)

-- ====================================================================================--
