-- ====================================================================================--
-- Chat System Configuration
-- ====================================================================================--

ig.chat = ig.chat or {}

ig.chat.config = {
    -- Enable/disable chat logging
    logging = {
        enabled = true,
        
        -- Log to daily chat history files
        logToFile = true,
        logDirectory = "logs/chat", -- Directory for chat logs
        
        -- Log to txAdmin
        logToTxAdmin = true,
        
        -- Log both messages and commands, or just commands
        logMessages = true, -- Regular chat messages
        logCommands = true, -- Commands (starting with /)
        
        -- Include metadata in logs
        includeCoordinates = false,
        includeIdentifiers = false,
        
        -- Maximum days to keep chat logs (0 = keep forever)
        maxLogDays = 30
    },
    
    -- Chat message settings
    messageSettings = {
        maxLength = 256, -- Maximum message length
        allowEmptyMessages = false,
        filterProfanity = false -- Future feature
    }
}

-- Function to format chat log entry
function ig.chat.FormatLogEntry(source, playerName, message, isCommand)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local identifiers = ""
    local coords = ""
    
    if ig.chat.config.logging.includeIdentifiers and source > 0 then
        local ids = ig.func.GetPlayerIdentifiers(source)
        if ids then
            identifiers = string.format(" [%s]", ids.steam or ids.license or "unknown")
        end
    end
    
    if ig.chat.config.logging.includeCoordinates and source > 0 then
        local ped = GetPlayerPed(source)
        if ped and ped > 0 then
            local playerCoords = GetEntityCoords(ped)
            coords = string.format(" @(%.1f, %.1f, %.1f)", playerCoords.x, playerCoords.y, playerCoords.z)
        end
    end
    
    local messageType = isCommand and "COMMAND" or "MESSAGE"
    return string.format("[%s] [%s] %s (ID: %d)%s%s: %s", 
        timestamp, 
        messageType,
        playerName, 
        source,
        identifiers,
        coords,
        message
    )
end

-- Example configuration - copy this to your server's config
--[[
-- Enable chat logging with all options
ig.chat.config.logging.enabled = true
ig.chat.config.logging.logToFile = true
ig.chat.config.logging.logToTxAdmin = true
ig.chat.config.logging.logMessages = true
ig.chat.config.logging.logCommands = true

-- Or use convars
local chatLogging = GetConvar('ig_chat_logging', 'true')
if chatLogging == 'true' then
    ig.chat.config.logging.enabled = true
end
]]--
