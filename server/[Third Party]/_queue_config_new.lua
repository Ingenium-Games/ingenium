--[[
    Queue Configuration
    
    Modern queue system configuration for Ingenium
    
    This replaces the old _queue_config.lua with a cleaner, more maintainable design
]]--

-- Initialize Queue configuration namespace
QueueConf = {}

--------------------------------------------------------------------------------
-- Basic Configuration
--------------------------------------------------------------------------------

-- Maximum players allowed on the server
-- Can be overridden by sv_maxclients convar
QueueConf.MaxPlayers = GetConvarInt("sv_maxclients", 48)

-- Enable debug logging
QueueConf.Debug = GetConvar("sv_debugqueue", "false") == "true"

-- Display queue count in server name
QueueConf.DisplayQueue = GetConvar("sv_displayqueue", "true") == "true"

-- Require Steam to connect
QueueConf.RequireSteam = false

-- Only allow players with priority to connect (whitelist mode)
QueueConf.PriorityOnly = false

--------------------------------------------------------------------------------
-- Timeout Configuration
--------------------------------------------------------------------------------

-- How long before removing a player from queue (seconds)
QueueConf.QueueTimeout = 90

-- How long before removing a player from connecting list (seconds)
QueueConf.ConnectTimeout = 600

-- How often to update queue position cards (milliseconds)
QueueConf.UpdateInterval = 500

--------------------------------------------------------------------------------
-- Grace Period Configuration
--------------------------------------------------------------------------------

-- Enable grace period for recently disconnected players
QueueConf.GraceEnabled = true

-- Priority power given during grace period
QueueConf.GracePower = 5

-- How long grace period lasts (seconds)
QueueConf.GraceTime = 300 -- 5 minutes

--------------------------------------------------------------------------------
-- Priority Configuration
--------------------------------------------------------------------------------

-- Static priority list (identifier: power)
-- Higher power = higher priority
-- Supports: license:, steam:, discord:, fivem:, ip:
QueueConf.PriorityList = {
    -- Example:
    -- ["license:abc123"] = 100,
    -- ["steam:110000103fd1bb1"] = 50,
    -- ["discord:123456789"] = 25,
}

-- Database supporter priority power
-- Players with Supporter = 1 in the users table get this priority
QueueConf.SupporterPriority = 10

-- Discord role priority is configured in _config/discord.lua
-- See conf.discord.priority_roles

--------------------------------------------------------------------------------
-- Connection Steps Configuration
--------------------------------------------------------------------------------

-- Register custom connection steps that run before player enters server
-- Each step can show a custom card and perform validation
QueueConf.ConnectionSteps = {
    -- Example step structure:
    --[[
    {
        id = "terms_of_service",
        title = "Terms of Service",
        description = "Please review our terms of service",
        showInQueue = true, -- Show this step info while in queue
        handler = function(src, callback)
            -- Your validation logic here
            -- callback(true) to proceed
            -- callback(false, "error message") to reject
            callback(true)
        end
    }
    ]]--
}

--------------------------------------------------------------------------------
-- Adaptive Card Customization
--------------------------------------------------------------------------------

-- Server branding for queue cards
QueueConf.ServerName = "Ingenium Server"
QueueConf.ServerIcon = "🎮"

-- Colors for adaptive cards (use Adaptive Cards color names)
QueueConf.CardColors = {
    accent = "Accent",      -- Queue position and highlights
    success = "Good",       -- Connection success
    warning = "Warning",    -- Warnings
    error = "Attention"     -- Errors and important alerts
}

-- Show additional information in queue
QueueConf.ShowServerInfo = true

-- Custom server information to display in queue
QueueConf.ServerInfo = {
    -- Example:
    -- {title = "Discord", value = "discord.gg/yourserver"},
    -- {title = "Website", value = "yourserver.com"},
}

--------------------------------------------------------------------------------
-- Localization
--------------------------------------------------------------------------------

-- Queue-specific localization (supplements main locale system)
QueueConf.Locale = {
    joining = "Joining server...",
    connecting = "Connecting to server...",
    position = "You are %d of %d in queue",
    estimated_wait = "Estimated wait: ~%d min",
    queue_time = "Time in queue: %s",
    server_message = "📢 Server Message",
    please_wait = "Please wait patiently. The queue moves automatically.",
    
    -- Error messages
    err_no_ids = "Error: Could not retrieve your identifiers. Please restart FiveM.",
    err_steam_required = "Error: Steam must be running to join this server.",
    err_banned = "You are banned from this server.\nReason: %s",
    err_connection_failed = "Connection failed. Please try again.",
    err_shutdown = "Server is restarting. Please try again shortly.",
    err_whitelist = "You must be whitelisted to join this server.",
    err_timeout = "Connection timed out. Please try again.",
}

--------------------------------------------------------------------------------
-- Advanced Configuration
--------------------------------------------------------------------------------

-- Allow server operators to add priority via exports
QueueConf.AllowExternalPriority = true

-- Log queue events to database or external system
QueueConf.LogQueueEvents = false

-- Average time per player in queue (for wait time estimation)
QueueConf.AvgWaitPerPlayer = 30 -- seconds

-- Maximum queue size (0 = unlimited)
QueueConf.MaxQueueSize = 0

--------------------------------------------------------------------------------
-- Backwards Compatibility
--------------------------------------------------------------------------------

-- Support for old Queue API
Queue = Queue or {}
Queue.MaxPlayers = QueueConf.MaxPlayers
Queue.Debug = QueueConf.Debug
Queue.DisplayQueue = QueueConf.DisplayQueue

--------------------------------------------------------------------------------
-- Configuration Validation
--------------------------------------------------------------------------------

Citizen.CreateThread(function()
    -- Validate priority roles configuration
    if conf and conf.discord and conf.discord.priority_enabled then
        if not conf.discord.priority_roles or #conf.discord.priority_roles == 0 then
            ig.log.Warn("Queue", "Discord priority is enabled but no priority roles are configured")
        end
    end
    
    -- Validate supporter priority
    if QueueConf.SupporterPriority > 0 then
        ig.log.Info("Queue", "Supporter priority enabled (power: %d)", QueueConf.SupporterPriority)
    end
    
    -- Log configuration
    if QueueConf.Debug then
        print("^3[Queue Config] Loaded with following settings:^7")
        print(("  Max Players: %d"):format(QueueConf.MaxPlayers))
        print(("  Grace Period: %s (power: %d, duration: %ds)"):format(
            QueueConf.GraceEnabled and "Enabled" or "Disabled",
            QueueConf.GracePower,
            QueueConf.GraceTime
        ))
        print(("  Queue Timeout: %ds"):format(QueueConf.QueueTimeout))
        print(("  Connect Timeout: %ds"):format(QueueConf.ConnectTimeout))
        print(("  Static Priorities: %d configured"):format(
            #QueueConf.PriorityList
        ))
    end
end)

ig.log.Info("Queue", "Configuration loaded")
