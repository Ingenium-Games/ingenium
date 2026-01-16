-- ====================================================================================--
-- Game Mode Configuration
-- Migrated from ig.base
-- ====================================================================================--

-- ====================================================================================--
-- Game Mode Specific Settings
-- ====================================================================================--

conf.modes = {
    -- Roleplay mode settings
    RP = {
        hideHud = true,              -- Hide default GTA HUD elements
        disableIdleCamera = true,    -- Disable idle camera after 5 seconds
        disableNPCWeaponDrops = true, -- Prevent NPCs from dropping weapons
        disableTrains = true,        -- Remove trains from the world
        disableDispatch = true,      -- Disable police dispatch
        enableVehicleTracking = true, -- Track vehicle entry/exit
    },
    
    -- Deathmatch mode settings
    DM = {
        hideHud = false,
        disableIdleCamera = false,
        disableNPCWeaponDrops = true,
        disableTrains = false,
        disableDispatch = true,
        enableVehicleTracking = false,
    },
    
    -- Team Deathmatch mode settings
    TDM = {
        hideHud = false,
        disableIdleCamera = false,
        disableNPCWeaponDrops = true,
        disableTrains = false,
        disableDispatch = true,
        enableVehicleTracking = false,
    },
    
    -- King of the Hill mode settings
    KOTH = {
        hideHud = false,
        disableIdleCamera = false,
        disableNPCWeaponDrops = true,
        disableTrains = false,
        disableDispatch = true,
        enableVehicleTracking = false,
    },
    
    -- Free Roam mode settings
    FR = {
        hideHud = false,
        disableIdleCamera = true,
        disableNPCWeaponDrops = false,
        disableTrains = false,
        disableDispatch = false,
        enableVehicleTracking = true,
    },
    
    -- Gun Game mode settings
    GG = {
        hideHud = false,
        disableIdleCamera = false,
        disableNPCWeaponDrops = true,
        disableTrains = false,
        disableDispatch = true,
        enableVehicleTracking = false,
    },
}