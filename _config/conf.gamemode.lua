-- ====================================================================================--
-- Game Mode Configuration
-- Migrated from ig.base
-- ====================================================================================--

conf = conf or {}
conf.gamemode = conf.gamemode or "RP"

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

-- ====================================================================================--
-- Helper Functions
-- ====================================================================================--

--- Get current game mode
---@return string gamemode
function GetGameMode()
    return conf.gamemode
end

--- Get game mode settings
---@param mode string|nil Game mode (defaults to current)
---@return table settings
function GetGameModeSettings(mode)
    mode = mode or conf.gamemode
    return conf.modes[mode] or conf.modes.RP
end

--- Check if feature is enabled for current game mode
---@param feature string Feature name
---@return boolean enabled
function IsGameModeFeatureEnabled(feature)
    local settings = GetGameModeSettings()
    return settings[feature] or false
end

-- Export functions
if IsDuplicityVersion() then
    -- Server-side exports
    exports("GetGameMode", GetGameMode)
    exports("GetGameModeSettings", GetGameModeSettings)
    exports("IsGameModeFeatureEnabled", IsGameModeFeatureEnabled)
else
    -- Client-side exports
    exports("GetGameMode", GetGameMode)
    exports("GetGameModeSettings", GetGameModeSettings)
    exports("IsGameModeFeatureEnabled", IsGameModeFeatureEnabled)
end
