-- ====================================================================================--
-- Helper Functions
-- ====================================================================================--
ig.game = {}

--- Get current game mode
---@return string gamemode
function ig.game.GetGameMode()
    return conf.gamemode
end

--- Get game mode settings
---@param mode string|nil Game mode (defaults to current)
---@return table settings
function ig.game.GetGameModeSettings(mode)
    mode = mode or conf.gamemode
    return conf.modes[mode] or conf.modes.RP
end

--- Check if feature is enabled for current game mode
---@param feature string Feature name
---@return boolean enabled
function ig.game.IsGameModeFeatureEnabled(feature)
    local settings = ig.game.GetGameModeSettings()
    return settings[feature] or false
end